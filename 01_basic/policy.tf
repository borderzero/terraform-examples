# variable for the user account email
variable "user_account_email" {
  description = "The email of the account owner"
  type        = string
  default     = "greg@border0.com"
}

variable "create_custom_policy" {
  description = "This variable controlls the creation of a custom policy"
  type        = bool
  default     = true # set this to false to skip createing a custom policy
}

resource "border0_policy_attachment" "playground_http_to_client-policy" {
  count     = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_http.id
}

resource "border0_policy_attachment" "playground_ssh_to_client-policy" {
  count     = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_ssh.id
}

resource "border0_policy_attachment" "playground_mysql_to_client-policy" {
  count     = var.create_custom_policy ? 1 : 0
  policy_id = border0_policy.my-tf-access-policy[0].id
  socket_id = border0_socket.playground_mysql.id
}

# create policy
resource "border0_policy" "my-tf-access-policy" {
  count       = var.create_custom_policy ? 1 : 0
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


resource "border0_policy" "my-v2-tf-doc_based_access-policy" {
  # depends_on = [ data.border0_policy_v2_document.my_v2_tf_access_policy_doc ]
  count       = var.create_custom_policy ? 1 : 0
  name        = "my-v2-tf-doc-based-access-policy"
  description = "My terraform managed document based access policy"
  version     = "v2"
  policy_data = data.border0_policy_v2_document.my_v2_tf_access_policy_doc.json
}

# v2 policy document matching the custom policy above
data "border0_policy_v2_document" "my_v2_tf_access_policy_doc" {
  permissions {
    ssh {
      allowed = true
      shell {
        allowed = true
      }
      exec {
        allowed = true
      }
      sftp {
        allowed = true
      }
      tcp_forwarding {
        allowed = true
      }
      kubectl_exec {
        allowed = true
      }
      docker_exec {
        allowed = true
      }
    }

    database {
      allowed = true
      allowed_databases {
        database            = "books"
        allowed_query_types = ["ReadOnly"]
      }
    }

    http { allowed = true }
    tls { allowed = true }
    vnc { allowed = true }
    rdp { allowed = true }
    network { allowed = true }
    kubernetes { allowed = true }
  }

  condition {
    who {
      email = [var.user_account_email]
    }
    where {
      allowed_ip = [
        "0.0.0.0/0",
        "::/0",
      ]
    }
    when {
      after = "2022-02-02T22:22:22Z"
    }
  }
}
