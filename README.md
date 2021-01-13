# Raspberry Pi home server setup as Code.

Because the server is using a microSD card one focus is to minimize disk read/write activity. Therefore I am using a lot of tmpfs devices where possible.

I am also using 
* <https://github.com/bobafetthotmail/folder2ram> to further reduce disk read/writes of the OS and
* <https://github.com/cloudalchemy/ansible-node-exporter> to install the node exporter.

## Instructions

Adjust the variables in `variables.tf` and remove all the `.tf` files of services which you don't need.

Then, run `terraform init` and `terraform apply`.