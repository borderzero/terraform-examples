variable "account_owner_email" {
  description = "The email of the account owner"
  type        = string
  default     = "greg@border0.com"
}
variable "create_default_policy" {
  description = "This variable controlls the creation of a org wide default policy identical to the default one"
  type        = bool
  default     = true # set this to false to skip creating a default policy
}


# this is a replica of border0 default policy
#
resource "border0_policy" "my-default-org-policy" {
  count       = var.create_default_policy ? 1 : 0
  name        = "default-org-policy-managed-by-terraform"
  description = "The Default Org Policy managed by Terraform"
  version     = "v2"
  org_wide    = true
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
      "kubernetes" : {},
    },
    "condition" : {
      "who" : {
        "email" : [var.account_owner_email],
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
