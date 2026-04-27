resource "aws_security_group" "pubToPriv" {
  name        = "pubToPriv"
  vpc_id      = aws_vpc.main.id
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
  name        = "public"
  vpc_id      = aws_vpc.main.id
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

module "dc_instance" {
  source             = "./modules/ec2-instance"
  ami_id             = var.windows_id
  instance_type      = var.instance_type
  key_pair           = var.key_pair
  subnet_id          = aws_subnet.private.id
  security_group_ids = [aws_security_group.pubToPriv.id]
  instance_name      = "Windows DC"
}

module "rhel_instance" {
  source             = "./modules/ec2-instance"
  ami_id             = var.rhel_id
  instance_type      = var.instance_type
  key_pair           = var.key_pair
  subnet_id          = aws_subnet.private.id
  security_group_ids = [aws_security_group.pubToPriv.id]
  instance_name      = "RHEL"
}

module "bastion_instance" {
  source             = "./modules/ec2-instance"
  ami_id             = var.windows_id
  instance_type      = var.instance_type
  key_pair           = var.key_pair
  subnet_id          = aws_subnet.public.id
  security_group_ids = [aws_security_group.public.id]
  instance_name      = "Windows bastion"
}