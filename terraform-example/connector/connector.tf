resource "border0_connector" "border0_connector" {
  name                         = "${var.prefix}-connector"
  description                  = "${var.prefix} connector in ${data.aws_region.current.name} region"
  built_in_ssh_service_enabled = true
}


resource "border0_connector_token" "border0_connector-token" {
  depends_on = [
    border0_connector.border0_connector,
  ]
  connector_id = border0_connector.border0_connector.id
  name         = var.prefix != "" ? "${var.prefix}-token" : "Border0-Example-Token"
  # Token expiry date in ISO 8601 format. If not set, token will never expire.
  # expires_at   = "2023-12-31T23:59:59Z"
  expires_at = ""
}


resource "aws_ssm_parameter" "border0-token-parameter" {
  name        = local.connector-token-param-path
  description = "${var.prefix} - Border0 runtime connector token"
  type        = "SecureString"
  depends_on  = [border0_connector_token.border0_connector-token]
  value       = border0_connector_token.border0_connector-token.token
  # in case of ParameterAlreadyExists error for aws_ssm_parameters
  # https://github.com/hashicorp/terraform-provider-aws/issues/25636 and https://github.com/hashicorp/terraform-provider-aws/issues/32736
  # overwrite = true
  tags = merge(
    { Name = "${var.prefix}-connector-token" },
    var.default_tags,
  )
}


resource "border0_policy_attachment" "built_in_ssh_service_policy_attachment" {
  policy_id = border0_policy.border0_policy.id
  socket_id = border0_connector.border0_connector.built_in_ssh_service_id
}


