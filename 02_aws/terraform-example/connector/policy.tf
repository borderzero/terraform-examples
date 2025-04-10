resource "border0_policy" "border0_policy" {
  name        = "${var.prefix}-tf-${data.aws_region.current.name}-policy"
  description = "${var.prefix}-tf policy for ${data.aws_region.current.name}"
  version     = "v2"
  policy_data = jsonencode({
    "condition" : {
      "when" : {
        "after" : "2022-02-02T22:22:22Z",
        "before" : null,
        "time_of_day_after" : "",
        "time_of_day_before" : ""
      },
      "where" : {
        "allowed_ip" : [
          "0.0.0.0/0",
          "::/0"
        ],
        "country" : [],
        "country_not" : null
      },
      "who" : {
        "email" : ["${var.access-email}"],
        "group" : [],
        "service_account" : []
      }
    },
    "permissions" : {
      "database" : {},
      "http" : {},
      "ssh" : {
        "docker_exec" : {},
        "exec" : {},
        "kubectl_exec" : {},
        "sftp" : {},
        "shell" : {},
        "tcp_forwarding" : {}
      }
    }
  })
}
