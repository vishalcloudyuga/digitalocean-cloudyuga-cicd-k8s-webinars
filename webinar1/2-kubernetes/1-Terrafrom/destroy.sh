#!/bin/bash


terraform destroy --force -var "pub_key=~/.ssh/id_rsa.pub" -var "pvt_key=~/.ssh/id_rsa"  -var "region=ams3" -var "ssh_fingerprint=$fingerprint" -var "do_token=$token" -var "size=2gb"
rm *.txt
rm -r terraform.tfstate.d

exit 0
