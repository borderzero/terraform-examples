# variable for the user account email
variable "user_account_email" {
  description = "The email of the account owner"
  type        = string
  default     = "greg@border0.com"
}

variable "create_custom_policy" {
  description = "This variable controlls the creation of a custom policy"
  type        = bool
  default     = false # set this to true to create a custom policy
}

resource "border0_policy_attachment" "playground_http_to_client-policy" {
  count = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_http.id
}

resource "border0_policy_attachment" "playground_ssh_to_client-policy" {
  count = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_ssh.id
}

resource "border0_policy_attachment" "playground_mysql_to_client-policy" {
  count = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_mysql.id
}

# create policy
resource "border0_policy" "my-tf-access-policy" {
  count = var.create_custom_policy ? 1 : 0
  name        = "my-tf-access-policy"
  description = "My terraform managed access policy"
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
      "database" : {
        "allowed_databases" : [
          {
            "database" : "books",
            "allowed_query_types" : [
              "ReadOnly"
            ]
          }
        ]
      },
      "http" : {},
      "tls" : {},
      "vnc" : {},
      "rdp" : {},
      "vpn" : {},
      "kubernetes" : {},
    },
    "condition" : {
      "who" : {
        "email" : [var.user_account_email],
        "group" : [],
        "service_account" : []
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

