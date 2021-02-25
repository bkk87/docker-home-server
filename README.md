# (Raspberry Pi) Docker Home Server Setup as Code

Using the Docker provider for Terraform to deploy Docker Infrastructure (Images, Containers, Networks, Volumes).

![](images/docker-terraform-raspi-lab.png)

In order to minimize disk read/write activity, tmpfs devices are used where data does not necessarily needs to be persisted (e.g. Prometheus metrics).

Other helpful projects:  
* <https://github.com/bobafetthotmail/folder2ram> to further reduce disk read/writes of the OS
* <https://github.com/cloudalchemy/ansible-node-exporter> to install the Node Exporter for gettng Prometheus Metrics

## Instructions

Remove all `.tf` files which you don't need. Also remove the corresponding variables in `variables.tf`. A lot of variables are provided with default values. Check and adjust the `examples.tfvars` file if you want to change some parameters.

Then, run `terraform init` and `terraform apply`.
