#!/bin/bash

apt-get update && apt-et dist-upgrade -yy

export INLETSTOKEN=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1)

curl -sLS https://get.inlets.dev | sudo sh

curl -sLO https://raw.githubusercontent.com/inlets/inlets/master/hack/inlets.service  && \
  mv inlets.service /etc/systemd/system/inlets.service && \
  echo "AUTHTOKEN=$INLETSTOKEN" > /etc/default/inlets && \
  systemctl start inlets && \
  systemctl enable inlets
