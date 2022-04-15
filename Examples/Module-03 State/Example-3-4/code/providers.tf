
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 3.0"
        }     
    }
    # Required version of terraform
    required_version = ">0.14"
      
}

terraform {
     backend "s3" {
        profile = "dev"
        # Replace this with your bucket name!
        bucket         = "terraform-zippy"
        key            = "myproj/terraform.tfstate"
        region         = "us-east-2"

        # Replace this with your DynamoDB table name!
        dynamodb_table = "zippy-locks"
        encrypt        = true
  }
} 

provider aws {
    region = "us-east-2"
    profile = "dev"
}

