terraform {
  required_providers {
    border0 = {
      source  = "borderzero/border0"
      version = ">= 3.0.25"
    }
  }
}

provider "border0" {
  # we use the token from the environment variable or the one provided in the variables file
  token = var.BORDER0_TF_TOKEN != null ? var.BORDER0_TF_TOKEN : null
}

#docker run -ti                         --name border0-connector                         --volume border0-volume:/root/.border0                         --publish 32442:32442/udp                         --cap-add NET_ADMIN                         --device /dev/net/tun                         --sysctl 'net.ipv4.ip_forward=1'                         --sysctl 'net.ipv6.conf.all.forwarding=1'                         ghcr.io/borderzero/border0                         connector start --invite fwwXLZeUTSj

output "everything" {
  value = {
    "To start the connector using cli"  = "sudo border0 connector start --config ${path.module}/border0.yaml"
    "To start a Docker based connector" = <<_
  sudo docker run --rm -ti \
    --name border0-connector \
    --volume border0-volume:/root/.border0 \
    --volume ${path.module}/border0.yaml:/etc/border0.yaml \
    --publish 32442:32442/udp \
    --cap-add NET_ADMIN \
    --device /dev/net/tun \
    --sysctl 'net.ipv4.ip_forward=1' \
    --sysctl 'net.ipv6.conf.all.forwarding=1' \
    ghcr.io/borderzero/border0 \
    connector start --config /etc/border0.yaml
  _
    "You can view your connector here:" = "https://portal.border0.com/connector/${border0_connector.first-connector.id}"
  }
}
