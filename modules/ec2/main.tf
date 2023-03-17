data "aws_ami" "docker" {
  owners = ["591542846629"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20230109-x86_64-ebs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}

data "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = data.aws_iam_role.ecs_instance_role.name
}

resource "aws_security_group" "example" {
  # ... other configuration ...

  name = "jenkins-sg"

  ingress {
    description = "Allows TCP on 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }


  ingress {
    description = "Allows TCP on 8080"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }



  ingress {
    description = "Allows TCP on 50000"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "ecs-server" {
  ami           = data.aws_ami.docker.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }

  user_data = "#!/bin/bash echo ECS_CLUSTER=your_cluster_name >> /etc/ecs/ecs.config"
}
