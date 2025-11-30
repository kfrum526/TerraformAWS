resource "aws_security_group" "pubToPriv"{
    name = "pubToPriv"
    vpc_id = aws_vpc.main.id
    description = "Allow traffic from public subnet to private instances"

    # Allow RDP from the public subnet (where the bastion is)
    ingress {
        description = "RDP from public subnet"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.public.cidr_block] # Reference the public subnet's CIDR
    }

    # Allow SSH from the public subnet (where the bastion is)
    ingress {
        description = "SSH from public subnet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [aws_subnet.public.cidr_block] # Reference the public subnet's CIDR
    }
}
resource "aws_security_group" "public" {
    name = "public"
    vpc_id = aws_vpc.main.id
    description = "Allow RDP from the internet and all outbound traffic"

    # For better security, you should replace "0.0.0.0/0" with your own IP address.
    ingress {
        description = "RDP from Internet"
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
}

########################################################################################################################
###################################################### EC2 #############################################################

resource "aws_instance" "DomainController" {
  ami           = var.windows_id
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
  ami           = var.rhel_id
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
  ami           = var.windows_id
  instance_type = var.instance_type
  key_name      = var.key_pair
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