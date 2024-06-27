# this is a replica of border0 default policy
#
# resource "border0_policy" "my-default-org-policy" {
#   name        = "default-org-policy-v2"
#   description = "The Default Org Policy managed by Terraform"
#   version     = "v2"
#   org_wide    = true
#   policy_data = jsonencode({
#     "permissions" : {
#       "ssh" : {
#         "shell" : {},
#         "exec" : {},
#         "sftp" : {},
#         "tcp_forwarding" : {},
#         "kubectl_exec" : {},
#         "docker_exec" : {}
#       },
#       "database" : {},
#       "http" : {},
#       "tls" : {},
#       "vnc" : {},
#       "rdp" : {},
#       "vpn" : {},
#       "kubernetes" : {},
#     },
#     "condition" : {
#       "who" : {
#         "email" : ["greg@border0.com"],
#         "group" : [],
#         "service_account" : []
#       },
#       "where" : {
#         "allowed_ip" : [
#           "0.0.0.0/0",
#           "::/0"
#         ],
#         "country" : null,
#         "country_not" : null
#       },
#       "when" : {
#         "after" : "2022-02-02T22:22:22Z",
#         "before" : null,
#         "time_of_day_after" : "",
#         "time_of_day_before" : ""
#       }
#     }
#   })
# }
