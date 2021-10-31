provider "aws" {
  region      = var.aws_region
  max_retries = 1
}

resource "aws_security_group" "swarm-node" {
  name = "swarm-node"

  ingress {
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swarm"
  }
}

resource "aws_instance" "swarm-node" {

  count = 3
  ami                    = var.ami_ubuntu_21_04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.swarm-node.id]

  user_data = <<-EOF
    #!/bin/bash
    mkdir .ssh
    chmod 700 .ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ+EkXbSvM8NVqcF3oZkbFIqgyMEy+cd6BMdmICV1CkiEkEmH3NtpDNtHMzZPNzuzeh6Ev+Wmz3XPD2HXrqRvNXuCnDAR4Gy0BRg2Y9LZ9xkEdWornRCO+J/LcZ3k41WG2CRJ2KguEq2iDPrIQwtGKN8hCp8Djysao0RyhSmsB+4G6vMpnr1FpuWjnGq1x98oIbHKT0HVx7Ka9mZs7OhGX5PmCkw8G3m9pxtJehHGlNuoEUaQdToMVlOvF7LGKA8HI7S9UyJHRi4Ieve7TXmO+eEhnYMAIBM+FOc5P3f+EfqIQthiWQqwAOynEa8NOmhAZIveXWNjeExypKn3Lt8q82C1FGL1lEx+R+dlbcwTAZSzh6/yFHHeXa/qlzXTt8PAjEgIUEv+pigiEjV0Rh97z6YxBEwIwY44O3lv+KA9Lo1vDy8FdBxOd2dBd+gsnXnrsL/IkmxPHESUmNjwflVdO1wreXAX4dlljj+gX1NN0ij2Vo3GIRXMWzUGI6Z/vmRE= acs@lsp-022" > ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/authorized_keys
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    service ssh start
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "Hello, World" > index.html
    pwd >> index.html
    id >> index.html
    nohup busybox httpd -f -p ${var.web_port} &
  EOF

  tags = {
    Name = "swarm"
  }
}