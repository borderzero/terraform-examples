resource "border0_connector" "border0_connector" {
  name                         = "connector-${data.aws_region.current.name}"
  description                  = "Example Border0 Connector in ${data.aws_region.current.name} region"
  built_in_ssh_service_enabled = true
}


resource "border0_connector_token" "border0_connector-token" {
  depends_on = [
    border0_connector.border0_connector,
  ]
  connector_id = border0_connector.border0_connector.id
  name         = "border0-connector-token-${data.aws_region.current.name}"
  expires_at   = "2023-12-31T23:59:59Z"
}


resource "aws_ssm_parameter" "border0-token-msinfra" {
  name        = "/border0/connector-token"
  description = "Border0 runtime connector token"
  type        = "SecureString"
  depends_on  = [border0_connector_token.border0_connector-token]
  value       = border0_connector_token.border0_connector-token.token
}


resource "border0_policy_attachment" "built_in_ssh_service_policy_attachment" {
  policy_id = border0_policy.border0_policy.id
  socket_id = border0_connector.border0_connector.built_in_ssh_service_id
}

resource "border0_policy" "border0_policy" {
  name        = "tf-${data.aws_region.current.name}-policy"
  description = "tf policy for ${data.aws_region.current.name}"
  policy_data = jsonencode({
    "action" : ["database", "ssh", "http", "tls"],
    "condition" : {
      "when" : {
        "after" : "2022-10-11T00:00:00Z",
        "before" : null,
      },
      "where" : {
        "allowed_ip" : ["0.0.0.0/0", "::/0"],
        "country" : ["NL", "BR", "US", "CA"],
        "country_not" : null
      },
      "who" : {
        "domain" : ["border0.com"]
        "email" : [
          "greg@border0.com",
          "andree@border0.com"
        ]
      }
    },
    "version" : "v1"
  })
}

