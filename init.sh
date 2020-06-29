#!/bin/bash

sudo yum -y install unzip wget && wget https://github.com/industrialdev/setup-centos8-lemp/archive/master.zip && unzip master.zip && cd setup-centos8-lemp-master && source setup_centos_server.sh
