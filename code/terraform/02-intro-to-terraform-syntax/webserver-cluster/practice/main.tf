terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~>4.0"
      }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "ec2_security_group" {

    name = var.instance_security_group_name

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}

resource "aws_launch_configuration" "ec2_billi_lc" {
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.ec2_security_group.id]

    user_data = <<-EOF
                echo "<h1><center>Hello!! Billi Meow</center></h2>" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
}

resource "aws_autoscaling_group" "ec2_billi_web_asg" {
    launch_configuration = aws_launch_configuration.ec2_billi_lc.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    target_group_arns = [ aws_lb_target_group.asg_target.id ]
    health_check_type = "ELB"

    min_size = 3
    max_size = 10
    
    tag {
        key = "Name"
        value = "billi-web-asg"
        propagate_at_launch = true
    }

    lifecycle {
      create_before_destroy = true
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "billi_web_lb" {
    name = "billi-web-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb_security_group.id]
}

resource "aws_lb_listener" "http_listner" {

    load_balancer_arn = aws_lb.billi_web_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
          content_type = "text/plain"
          message_body = "404: Page not Found"
          status_code = 404
      }
    }
}

resource "aws_security_group" "alb_security_group" {
    name = "alb-security-group"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_lb_target_group" "asg_target" {

    name = "as-target"

    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id

    
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold  = 2
        unhealthy_threshold = 2
    }
  
}

resource "aws_lb_listener_rule" "asg_listener_rule" {
    listener_arn = aws_lb_listener.http_listner.arn
    priority = 100

    condition {
      path_pattern {
          values=["*"]
      }
    }
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg_target.arn
    }
}

