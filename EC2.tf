resource "aws_security_group" "pubToPriv"{
    name = "pubToPriv"
    description = "Specifically for bastion hosts in public subnet to connect to hosts in private subnet"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }
}

resource "aws_security_group" "pub" {
    name = "public"
    description = "Internet Traffic"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }
}

########################################################################################################################
###################################################### EC2 #############################################################

resource "aws_instance" "DomainController" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = aws_subnet.private.id
  security_groups = [
    aws_security_group.pubToPriv.id
  ]

  tags = {
    Name = "DC01"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
  }
}

resource "aws_instance" "RHEL" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = aws_subnet.private.id
  security_groups = [
    aws_security_group.pubToPriv.id
  ]

  tags = {
    Name = "RHEL"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
  }
}


resource "aws_instance" "Bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "my-key-pair"
  subnet_id     = aws_subnet.public.id
  security_groups = [
    aws_security_group.public.id
  ]

  tags = {
    Name = "Windows Basiton"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
  }
}