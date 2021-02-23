# (Raspberry Pi) Docker Home Server Setup as Code

Using the Docker provider for Terraform to deploy Docker Infrastructure (Images, Containers, Networks, Volumes).

![](images/docker-terraform-raspi-lab.png)

In order to minimize disk read/write activity, tmpfs devices are used where data does not necessarily need to be persisted (e.g. Prometheus metrics).

Other helpful projects:  
* <https://github.com/bobafetthotmail/folder2ram> to further reduce disk read/writes of the OS
* <https://github.com/cloudalchemy/ansible-node-exporter> to install the Node Exporter for gettng Prometheus Metrics

## Instructions

Adjust the variables in `variables.tf` and remove all the `.tf` files of services which you don't need.

Then, run `terraform init` and `terraform apply`.