// Starting point

module "SecGrp" {
  source = "../SG"
  access_port = var.access_port
  sg_name = "Test SG"
}

module "hello_app" {
  source = "../EC2"
  instance_type = var.instance_type
  app_name = var.app_name
  sg_groups = [module.SecGrp.secgps]

}

data "aws_security_group" "default_sg" {
  name = "default"
}
