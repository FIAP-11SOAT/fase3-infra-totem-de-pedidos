resource "aws_secretsmanager_secret" "secrets" {
    name        = "devops-team/infra-secrets"
    description = "Secret for my infrastructure"
}

resource "aws_secretsmanager_secret_version" "secrets" {
    secret_id     = aws_secretsmanager_secret.secrets.id
    secret_string = jsonencode({
        "RDS_POSTGRES" = {
            "database" = module.rds.db_instance_name
            "username" = module.rds.db_instance_username
            "password" = random_password.rds_password.result
        }
    })
}