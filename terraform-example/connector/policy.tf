locals {
  access-email = var.access-email != "" ? var.access-email : "example-email2@example.com"
}

resource "border0_policy" "border0_policy" {
  name        = "${var.prefix}-tf-${data.aws_region.current.name}-policy"
  description = "${var.prefix}-tf policy for ${data.aws_region.current.name}"
  policy_data = <<EOF
{
  "action": ["database", "ssh", "http", "tls"],
  "condition": {
    "when": {
      "after": "2022-10-11T00:00:00Z",
      "before": null
    },
    "where": {
      "allowed_ip": ["0.0.0.0/0", "::/0"],
      "country_not": null
    },
    "who": {
      "domain": ["example.com"],
      "email": [
        "example-email1@example.com",
        "${local.access-email}"
      ]
    }
  },
  "version": "v1"
}
EOF
}