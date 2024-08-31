locals {
    private_subnet_id_final = element(split(",", data.aws_ssm_parameter.private_subnet_ids.value), 0)

}