variable "tags" {
  default = {
    terraform = "true"
  }
}

variable "key_name" {
  description = "SSH KeyPair"
}

variable "hostname" {
  description = "EC2 hostname"
  default     = "tick_stack"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "sg_name" {
  description = "Security Group name"
  default     = "tick_sg"
}

variable "sg_description" {
  description = "SG description"
  default     = "Allow InfluxDB, Chronograf & SSH access"
}
