# TICK Stack

* Telegraf
* InfluxDB
* Chronograf
* Kapacitor

# How to use

## SSH

* Install ansible
```
$ sudo apt-get install ansible -y
```

* Setup ssh keys

```
$ ssh-keygen -t rsa -C "my-aws-key" -f ~/.ssh/my-aws-key
$ aws ec2 import-key-pair --key-name "my-aws-key" --public-key-material file://~/.ssh/my-aws-key.pub
$ aws ec2 describe-key-pairs
```

## Terraform

* Initialize AWS plugins and modules:

```
$ terraform init
```

* Generate and show an execution plan:

```
$ terraform plan
```

* Create the AWS resources:

```
$ terraform apply
```
