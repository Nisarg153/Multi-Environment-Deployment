#!/bin/bash

HOME2=$PWD

export TF_VAR_aws_region="us-east-1"
echo " "
echo "==> Create the resources :$TF_VAR_aws_region"
echo " "

cd $HOME2/envs/dev
terraform init
terraform apply -auto-approve