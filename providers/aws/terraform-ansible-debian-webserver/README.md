# terraform-ansible-debian-webserver

This repository is the simple example of deploying and provisioning a web server on Amazon Web Services (AWS), using [Terraform](https://www.terraform.io/) and [Ansible](http://docs.ansible.com/ansible/). Based on:

## Details

This repository sets up:

* A security group
* An SSH key pair
* A publicly-accessible EC2 instance (Debian)
* Within the instance:
   * Python
   * Nginx

## Setup

1. Install the following locally:
    * [Terraform](https://www.terraform.io/) <= 0.12.x
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)
    * Python (see [requirements](https://docs.ansible.com/ansible/latest/intro_installation.html#control-machine-requirements))
    * [pip](https://pip.pypa.io/en/stable/installing/)
1. Set up AWS credentials in [`~/.aws/credentials`](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files).
    * The easiest way to do so is by [setting up the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html).
1. Ensure you have an SSH public key at `~/.ssh/id_rsa.pub`.
    * [How to generate](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

## Usage

```sh
export AWS_DEFAULT_REGION=us-east-1
pip install -r requirements.txt

```

[More information about the AWS environment variables](https://www.terraform.io/docs/providers/aws/#environment-variables).
If it is successful, you should see an `public_ip` printed out at the end.

## Cleanup

```sh
make destroy
```
