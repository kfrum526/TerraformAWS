#!/bin/bash

source EKS_Vars.sh

aws sts get-caller-identity

aws eks --region us-east-1 update-kubeconfig --name $CLUSTERNAME