#!/usr/bin/env bash
echo "border0-example-connector" > /etc/hostname ; hostname -F /etc/hostname
apt-get update && sudo apt-get -y install gpg curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.border0.com/deb/gpg | gpg --dearmor -o /etc/apt/keyrings/border0.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/border0.gpg] https://download.border0.com/deb/ stable main" > /etc/apt/sources.list.d/border0.list
apt-get -y update
BORDER0_TOKEN=${border0_connector_token_path} apt-get -y install border0
border0 --version
#eof