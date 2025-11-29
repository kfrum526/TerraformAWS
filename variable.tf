variable "eks_name" {
    default = "testcluster"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-0abcdef1234567890"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "key_pair" {
  description = "The key pair for the EC2 instance."
  type        = string
  default     = "In_S3_Bucket"
}