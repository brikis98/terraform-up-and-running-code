provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  ami               = "ami-40d28157"

  user_data = <<-EOF
              #!/bin/bash
              sudo service apache2 start
              EOF
}

resource "aws_db_instance" "db" {
  allocated_storage = 10
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  name              = "mydb"
  username          = "admin"
  password          = "password"
}

resource "aws_elb" "load_balancer" {
  name               = "frontend-load-balancer"
  instances          = ["${aws_instance.app.id}"]
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
