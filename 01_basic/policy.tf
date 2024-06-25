resource "border0_policy_attachment" "playground_http_to_client-policy" {
  policy_id = border0_policy.my-access-policy.id
  socket_id = border0_socket.playground_http.id
}

resource "border0_policy_attachment" "playground_ssh_to_client-policy" {
  policy_id = border0_policy.my-access-policy.id
  socket_id = border0_socket.playground_ssh.id
}

resource "border0_policy_attachment" "playground_mysql_to_client-policy" {
  policy_id = border0_policy.my-access-policy.id
  socket_id = border0_socket.playground_mysql.id
}

# create policy
resource "border0_policy" "my-access-policy" {
  name        = "my-access-tf-policy"
  description = "My access terraform policy"
  version     = "v2"
  policy_data = jsonencode({
    "permissions" : {
      "ssh" : {
        # "allowed_usernames" : [
        #   "ubuntu"
        # ],
        "shell" : {},
        "exec" : {},
        "sftp" : {},
        "tcp_forwarding" : {},
        "kubectl_exec" : {},
        "docker_exec" : {}
      },
      "database" : {},
      #   "database" : {
      #     "allowed_databases" : [
      #       {
      #         "database" : "*",
      #         "allowed_query_types" : [
      #           "ReadOnly"
      #         ]
      #       }
      #     ]
      #   },
      "http" : {},
      "tls" : {},
      "vnc" : {},
      "rdp" : {},
      "vpn" : {},
      "kubernetes" : {},
    },
    "condition" : {
      "who" : {
        "email" : ["greg@border0.com"],
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
