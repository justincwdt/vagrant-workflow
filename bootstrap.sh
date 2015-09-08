#!/bin/bash

#Bombs out on any error
set +e

#Shows you each command and the result
set +x

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" \
--force-yes -fuy dist-upgrade

touch /root/test
