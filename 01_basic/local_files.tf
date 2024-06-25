# generate a helper script to start the connector
resource "local_file" "write_runtime_script" {
  content  = <<EOF
#!/bin/bash
# terraform examples 01_basic helper script
function show_help() {
    echo "Usage: $0 { start }"
    echo "  start: starts the connector in the background using the configuration in border0.yaml"
    echo "         invokes: border0 connector start --config ${path.module}/border0.yaml &"
}

case $1 in
  start)
    echo -e "\nConnector being started in the background!\n\n"
    set -x
    border0 connector start --config ${path.module}/border0.yaml &
    set +x
    ;;
  *)
    show_help
    ;;
esac

EOF
  filename = "${path.module}/runme.sh"
}

