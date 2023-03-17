terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = local.region
}

module "ec2_machine" {
  source = "./modules/ec2"
}


module "jenkins_server" {
  depends_on = [
    module.ec2_machine
  ]
  source = "./modules/ecs"
}
