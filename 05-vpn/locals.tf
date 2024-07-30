locals {
    public_subnet_id_final = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)

}