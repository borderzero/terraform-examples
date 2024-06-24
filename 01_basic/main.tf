terraform {
  required_version = ">= 0.14.0"
  required_providers {
    border0 = {
      source  = "borderzero/border0"
      version = ">= 2.0.7"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1"
    }
  }
}


provider "border0" {
  # we use the token from the environment variable or the one provided in the variables file
  token = var.BORDER0_TF_TOKEN != null ? var.BORDER0_TF_TOKEN : null
}

# create connector 
resource "border0_connector" "first-connector" {
  name                         = "first-connector"
  description                  = "My first connector created from terraform"
  built_in_ssh_service_enabled = true
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

# generate a helper script to start the connector
resource "local_file" "write_runtime_script" {
  content  = <<EOF
#!/bin/bash
# terraform examples 01_basic helper script
function show_help() {
    echo "Usage: $0 { start }"
    echo "  start: starts the connector in the background using the configuration in border0.yaml"
    echo "         invokes: border0 connector start --config ${path.module}/border0.yaml &"
}

case $1 in
  start)
    echo -e "\nConnector being started in the background!\n\n"
    set -x
    border0 connector start --config ${path.module}/border0.yaml &
    set +x
    ;;
  *)
    show_help
    ;;
esac

EOF
  filename = "${path.module}/runme.sh"
}

# we will use out playgground/sandbox server as targets for our sockets 
# more infor here: https://docs.border0.com/docs/faq#are-there-any-example-or-sandbox-server-i-can-connect-to

# playground http socket
resource "border0_socket" "playground_http" {
  recording_enabled = false
  name         = "playground-http"
  socket_type  = "http"
  connector_id = border0_connector.first-connector.id
  description = "My playground HTTP socket"

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
  name         = "playground-ssh"
  socket_type  = "ssh"
  connector_id = border0_connector.first-connector.id
  description = "My playground SSH socket"

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
  name         = "playground-mysql"
  socket_type  = "database"
  connector_id = border0_connector.first-connector.id
  description = "My playground MySQL socket"

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


output "everything" {
  value = {
    "Please run this CLI script" = "./runme.sh"
    "You can view your infrastructure in the Admin Portal" = "https://portal.border0.com/"
  }
}
