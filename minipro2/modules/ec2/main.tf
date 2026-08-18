# modules/ec2/main.tf

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
dnf update -y
dnf install -y httpd php php-mysqlnd mariadb105

echo "OK" > /var/www/html/health.html

systemctl start httpd
systemctl enable httpd

cat <<'PHP_EOF' > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>3-Tier Web Server Status</title>
</head>
<body>
    <h1>3-Tier Web-DB Server Architecture</h1>
    <div>
        <strong>EC2 Web/WAS Instance Info:</strong><br>
        Server IP: <?php echo $_SERVER['SERVER_ADDR']; ?><br>
        Hostname: <?php echo gethostname(); ?>
    </div>

<h2>Database Connection Status</h2>
    <?php
    $db_host = "${var.db_endpoint}";
    $db_user = "${var.db_username}";
    $db_pass = "${var.db_password}";
    $db_name = "${var.db_name}";

    mysqli_report(MYSQLI_REPORT_STRICT); // 예외 발생 모드 명시

    try {
        $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
        echo "<div>[  OK  ] Database Connection Successful!</div>";
        $result = $conn->query("SELECT VERSION() AS ver");
        $row = $result->fetch_assoc();
        echo "<div>MySQL Version: " . htmlspecialchars($row['ver']) . "</div>";
        $conn->close();
    } catch (Exception $e) {
        echo "<div>[ FAIL ] Database Connection Failed! Error: " . htmlspecialchars($e->getMessage()) . "</div>";
    }
    ?>
</body>
</html>
PHP_EOF

systemctl restart httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-web-was"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.project_name}-asg-"
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  health_check_type   = "ELB"
  health_check_grace_period = 300

  target_group_arns = var.target_group_arns

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
}
