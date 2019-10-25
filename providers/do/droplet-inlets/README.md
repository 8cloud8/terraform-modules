# Digital Ocean Droplet launch and setting the Domain records at Digital Ocean.

The example launches an Ubuntu, and installs inlets [https://github.com/inlets/inlets].
To run, configure your Digital Ocean provider as described in https://www.terraform.io/docs/providers/do/index.html

## Prerequisites
You need to export you DigitalOcean API Token as an environment variable

    export DIGITALOCEAN_TOKEN="Put Your Token Here"

## Run this example using:

    terraform plan
    terraform apply
