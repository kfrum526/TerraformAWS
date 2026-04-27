variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
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

variable "volume_size" {
  description = "size ofvolume in GB"
  type        = string
  default     = "100"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "instance_name" {
  description = "name of instance"
  type = string
}

variable "subnet_id" {
  description = "subnet id"
  type = string
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
