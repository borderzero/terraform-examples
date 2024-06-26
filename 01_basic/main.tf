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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
}

provider "time" {
  alias = "default"
}

resource "time_offset" "expiry_7d" {
  provider     = time.default
  offset_hours = 168 # 7 days * 24 hours/day
}

variable "BORDER0_TF_TOKEN" {
  description = "Border0 Token"
  sensitive   = true
  default     = null
}

provider "border0" {
  token = var.BORDER0_TF_TOKEN != null ? var.BORDER0_TF_TOKEN : null
}

resource "border0_user" "matt" {
  email           = "matt@border0.com"
  display_name    = "Matt Mclintock"
  role            = "admin"
  notify_by_email = false
}

data "border0_user_emails_to_ids" "existing_users" {
  emails = ["greg@border0.com"]
}

resource "border0_user" "andree" {
  email           = "andree@border0.com"
  display_name    = "Andree Toonk"
  role            = "admin"
  notify_by_email = false
}

resource "border0_group" "admins" {
  display_name = "admins"
  members = concat([
    border0_user.matt.id,
    border0_user.andree.id,
    ],
    toset(data.border0_user_emails_to_ids.existing_users.ids)[*]
  )
}

resource "border0_service_account" "admin-service-account" {
  name        = "admin-service-account"
  description = "Demo Admin Service Account"
  role        = "admin"
}


# create Admin service accoutn and token
resource "border0_service_account_token" "admin-service-account-token" {
  expires_at           = time_offset.expiry_7d.rfc3339
  name                 = "admin-service-account-token"
  service_account_name = border0_service_account.admin-service-account.name
}

# create Client service account and token
resource "border0_service_account" "client-access-service-account" {
  name        = "client-access-service-account"
  description = "Demo client-access Service Account"
  role        = "client"
}

resource "border0_service_account_token" "client-access-service-account-token" {
  expires_at           = time_offset.expiry_7d.rfc3339
  name                 = "client-access-service-account-token"
  service_account_name = border0_service_account.client-access-service-account.name
}

# create connector and token
resource "border0_connector" "first-connector" {
  name                         = "first-connector"
  description                  = "My first connector created from terraform"
  built_in_ssh_service_enabled = true
}
resource "border0_policy_attachment" "first-connector_to_admin-policy" {
  policy_id = border0_policy.my-admin-service-account-policy.id
  socket_id = border0_connector.first-connector.built_in_ssh_service_id
}

resource "border0_connector_token" "first-connector_token" {
  expires_at   = time_offset.expiry_7d.rfc3339
  connector_id = border0_connector.first-connector.id
  name         = "first-connector-token"
}

resource "local_file" "write_token_first-connector-token" {
  content  = "token: ${border0_connector_token.first-connector_token.token}"
  filename = "${path.module}/border0.yaml"
}

resource "local_file" "write_runtime_script" {
  content  = <<EOF
#!/bin/bash
# terraform examples 01_basic helper script, all tokens will get expired in 7 days 
function show_help() {
    echo "Usage: $0 { start | client-access | admin-access }"
    echo "  start: starts the connector in the background using the configuration in border0.yaml"
    echo "         invokes: border0 connector start --config ${path.module}/border0.yaml &"
    echo "  client-access: list the client-accessible hosts"
    echo "  admin-access: list the admin-accessible sockets"
}

case $1 in
  start)
    echo -e "\nConnector being started in the background!\nTry running:\n ./runme.sh client-access or ./runme.sh admin-access\n\n"
    set -x
    border0 connector start --config ${path.module}/border0.yaml &
    set +x
    ;;
  client-access)
    set -x
    BORDER0_CLIENT_TOKEN="${border0_service_account_token.client-access-service-account-token.token}" border0 client hosts -t http,ssh,database
    set +x
    ;;
  admin-access)
    set -x
    BORDER0_ADMIN_TOKEN="${border0_service_account_token.admin-service-account-token.token}" border0 socket ls
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
resource "border0_policy_attachment" "playground_http_to_client-policy" {
  policy_id = border0_policy.my-client-access-service-account-policy.id
  socket_id = border0_socket.playground_http.id
}
resource "border0_policy_attachment" "playground_http_to_admin-policy" {
  policy_id = border0_policy.my-admin-service-account-policy.id
  socket_id = border0_socket.playground_http.id
}

#playground ssh socket
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
resource "border0_policy_attachment" "playground_ssh_to_client-policy" {
  policy_id = border0_policy.my-client-access-service-account-policy.id
  socket_id = border0_socket.playground_ssh.id
}
resource "border0_policy_attachment" "playground_ssh_to_admin-policy" {
  policy_id = border0_policy.my-admin-service-account-policy.id
  socket_id = border0_socket.playground_ssh.id
}

# database socket
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
resource "border0_policy_attachment" "playground_mysql_to_client-policy" {
  policy_id = border0_policy.my-client-access-service-account-policy.id
  socket_id = border0_socket.playground_mysql.id
}
resource "border0_policy_attachment" "playground_mysql_to_admin-policy" {
  policy_id = border0_policy.my-admin-service-account-policy.id
  socket_id = border0_socket.playground_mysql.id
}

# create policy
resource "border0_policy" "my-client-access-service-account-policy" {
  name        = "my-client-access-service-account-tf-policy"
  description = "My client-access-service-account terraform policy"
  version     = "v2"
  policy_data = jsonencode({
    "permissions" : {
      "ssh" : {
        "shell" : {},
        "exec" : {},
        "sftp" : {},
        "tcp_forwarding" : {},
        "kubectl_exec" : {},
        "docker_exec" : {}
      },
      "database" : {},
      "http" : {},
      "tls" : {},
      "vnc" : {},
      "rdp" : {},
      "vpn" : {},
    },
    "condition" : {
      "who" : {
        "email" : [],
        "group" : [],
        "service_account" : [
        border0_service_account.client-access-service-account.name]
      },
      "where" : {
        "allowed_ip" : [
          "0.0.0.0/0",
          "::/0"
        ],
        "country" : null,
        "country_not" : null
      },
      "when" : {
        "after" : "2022-02-02T22:22:22Z",
        "before" : null,
        "time_of_day_after" : "",
        "time_of_day_before" : ""
      }
    }
  })
}

resource "border0_policy" "my-admin-service-account-policy" {
  name        = "my-admin-service-account-tf-policy"
  description = "My admin-service-account terraform policy"
  version     = "v2"
  policy_data = jsonencode({
    "permissions" : {
      "ssh" : {
        "shell" : {},
        "exec" : {},
        "sftp" : {},
        "tcp_forwarding" : {},
        "kubectl_exec" : {},
        "docker_exec" : {}
      },
      "database" : {},
      "http" : {},
      "tls" : {},
      "vnc" : {},
      "rdp" : {},
      "vpn" : {},
    },
    "condition" : {
      "who" : {
        "email" : [],
        "group" : [border0_group.admins.id],
        "service_account" : [
          border0_service_account.admin-service-account.name
        ]
      },
      "where" : {
        "allowed_ip" : [
          "0.0.0.0/0",
          "::/0"
        ],
        "country" : null,
        "country_not" : null
      },
      "when" : {
        "after" : "2022-02-02T22:22:22Z",
        "before" : null,
        "time_of_day_after" : "",
        "time_of_day_before" : ""
      }
    }
  })
}


output "everything" {
  value = {
    "Please run this CLI script" = "./runme.sh"
    "You can view your infrastructure in the Admin Portal" = "https://portal.border0.com/"
  }
}
