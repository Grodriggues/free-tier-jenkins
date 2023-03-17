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

resource "aws_security_group" "sg" {
  name = "jenkins-sg"
}

resource "aws_security_group_rule" "http_access" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "daemon_port" {
  type              = "ingress"
  from_port         = 50000
  to_port           = 50000
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "ssh_port" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_instance" "ecs_server" {
  ami             = data.aws_ami.docker.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.name]
  key_name        = "jenkins"

  tags = {
    Name = "HelloWorld"
  }

  user_data = <<EOF
		#! /bin/bash
    echo ECS_CLUSTER=jenkins-server >> /etc/ecs/ecs.config
	EOF
}
