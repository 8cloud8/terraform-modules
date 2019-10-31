module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = data.aws_vpc.default.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8083
      to_port     = 8083
      protocol    = "tcp"
      description = "InfluxDB admin dashboard"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8086
      to_port     = 8086
      protocol    = "tcp"
      description = "InfluxDB API"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8888
      to_port     = 8888
      protocol    = "tcp"
      description = "Chronograf Dashboard"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_blocks = "${chomp(data.http.my_ip.body)}/32"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "ec2_instance" {
  source                      = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  name                        = "${var.hostname}"
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = "${var.key_name}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  user_data = "${file("${path.module}/user_data.sh")}"
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  associate_public_ip_address = true
}

locals {
  tick_ip = "module.ec2_instance.public_dns[0]"
}
