terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 4.0"
      }
  }
  #first run terraform apply with the below backend block commented. 
  #   - This will create the S3 bucket and DynamoDB needed to store the terraform state
  #AFter that uncomment the below backend block and run "terraform init". This will export the staefile to AWS S3 backend 
  backend "s3" {

    bucket = "pp-terraform-up-and-running-state"
    key = "workspace-example/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
    
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "billi_ec2_inst_1" {

    ami = "ami-0fb653ca2d3203ac1"
    instance_type = terraform.workspace == "default" ? "t2.medium"  :  "t2.micro"
  
}
