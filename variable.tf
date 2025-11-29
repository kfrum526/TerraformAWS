variable "eks_name" {
    default = "testcluster"
}

variable "windows_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-0b4bc1e90f30ca1ec"
}

variable "rhel_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
  default     = "ami-069e612f612be3a2b"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
  default     = "t3.xlarge"
}

variable "key_pair" {
  description = "The key pair for the EC2 instance."
  type        = string
  default     = "In_S3_Bucket"
}