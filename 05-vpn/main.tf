#openvpn is a key based AMI so generating keypair using terraform
resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  # public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkBelb1e7Yg8spL1gzRfIGcnfUpUe3cVbASEzYkzi2v Leela@LEELA-DESKTOP"
  public_key = file ("~/.ssh/github.pub")
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #convert stringList to list and get first element
  subnet_id              = local.public_subnet_id_final
  ami = data.aws_ami.ami_info.id
  tags = merge (var.common_tags,
  var.vpn_tags,
  {
    Name = "${var.project_name}-${var.environment}-vpn"
  }
  )
}