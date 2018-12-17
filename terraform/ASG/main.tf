terraform {
  required_version = ">= 0.8, < 0.12"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "myEC2LaunchConfig" {
  image_id               = "ami-40d28157"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.my_instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_instance" {
  name = "single_server-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}
resource "aws_autoscaling_group" "My_ASG" {
  launch_configuration = "${aws_launch_configuration.myEC2LaunchConfig.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  min_size             = 2
  max_size             = 5

  tag {
    key                 =  "Name"
    value               =  "ASG_Example"
    propagate_at_launch = true
  }
}




