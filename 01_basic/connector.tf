# create connector 
resource "border0_connector" "first-connector" {
  name        = "first-connector"
  description = "My first connector created from terraform"
}

# create connector token
resource "border0_connector_token" "first-connector_token" {
  # expires_at   = "2077-12-31T00:00:00Z" # optional expiry date in RFC3339 format
  connector_id = border0_connector.first-connector.id
  name         = "first-connector-token"
}

# generate minimal connector configuration file with the token
resource "local_file" "write_token_first-connector-token" {
  content  = "token: ${border0_connector_token.first-connector_token.token}"
  filename = "${path.module}/border0.yaml"
}
