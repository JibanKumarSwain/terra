# this file name is we can do like "main.tf" or "ec2.tf" we can do any thinks

# key pain (login)
resource "aws_key_pair" "terrakey" {
  key_name   = "jibankey"
  public_key = file("jibankey.pub")

}

#vpc & security group
resource "aws_default_vpc" "default" {
}
resource "aws_security_group" "sgroup" {
  name        = "jiban-sg"
  description = "jiban create this sg group"
  vpc_id      = aws_default_vpc.default.id # this is know as interpolation(inserting or evaluating expressions inside strings, often to reference values like variables, resource attributes, or functions)

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh-open"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "node api"
  }
  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }
  tags = {
    Name = "jiban-sg"
  }
}

#ec2 instance
resource "aws_instance" "terra" {
  for_each = tomap({
    ec2-serer-main = "t2.small"
    ec2-server-UIUX = "t2.micro"
  })

  # meta_arumant  
  depends_on = [ aws_security_group.sgroup, aws_key_pair.terrakey ]   # this line help to stage the argument step by step like  key then vpc then SG then ec2

  key_name        = aws_key_pair.terrakey.key_name
  security_groups = [aws_security_group.sgroup.name]
  instance_type   = each.value   #we can update as for the variables
  ami             = var.ec2_ami_id
  user_data       = file("install_nginx.sh") #(this line help to do the installation on farst time on ec2 lunch time)
  root_block_device {
    volume_size = var.env == "stag" ? 20 : var.ec2_defult_volume_size  # in this place we are using the conditional statment update on var.tf
    volume_type = "gp3"
  }
  tags = {
    name = "jiban-ec2"
  }
}


# # import

# resource "aws_instance" "my_new_instance" {
#   ami = "unknown"
#   instance_type = "unknown"
  
# }

# import {
#   to = aws_key_pair.deployer
#   id = "deployer-key"
# }
