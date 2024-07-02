# we will use out playgground/sandbox server as targets for our sockets 
# more infor here: https://docs.border0.com/docs/faq#are-there-any-example-or-sandbox-server-i-can-connect-to

# playground http socket
resource "border0_socket" "playground_http" {
  recording_enabled = false
  name              = "playground-http"
  socket_type       = "http"
  connector_id      = border0_connector.first-connector.id
  description       = "My playground HTTP socket"

  http_configuration {
    upstream_url = "http://http.playground.border0.io"
  }
  tags = {
    "border0_client_subcategory" = "The Cloud"
    "border0_client_category"    = "Playground"
  }
}


# playground ssh socket
resource "border0_socket" "playground_ssh" {
  recording_enabled = false
  name              = "playground-ssh"
  socket_type       = "ssh"
  connector_id      = border0_connector.first-connector.id
  description       = "My playground SSH socket"

  ssh_configuration {
    hostname            = "ssh.playground.border0.io"
    port                = 22
    authentication_type = "username_and_password"
    username            = "border0"
    password            = "Border0<3Ssh"
  }
  tags = {
    "border0_client_subcategory" = "The Cloud"
    "border0_client_category"    = "Playground"
  }
}

# playgroud database socket
resource "border0_socket" "playground_mysql" {
  recording_enabled = false
  name              = "playground-mysql"
  socket_type       = "database"
  connector_id      = border0_connector.first-connector.id
  description       = "My playground MySQL socket"

  database_configuration {
    protocol            = "mysql"
    hostname            = "mysql.playground.border0.io"
    port                = 3306
    authentication_type = "username_and_password"
    username            = "border0"
    password            = "Border0<3MySql"
  }
  tags = {
    "border0_client_subcategory" = "The Cloud"
    "border0_client_category"    = "Playground"
  }
}
