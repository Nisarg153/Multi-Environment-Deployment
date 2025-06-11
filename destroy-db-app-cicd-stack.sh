#!/bin/bash

HOME2=$PWD


export TF_VAR_aws_region="us-east-1"

#----------------------------------------------------------
# Destroy the resources
#---------------------------------------------------------
echo " "
echo "==> Destroy the resources :$TF_VAR_aws_region"
echo " "

cd $HOME2/envs/dev

terraform destroy -auto-approve

