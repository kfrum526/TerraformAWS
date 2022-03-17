#!/bin/bash

source EKS_Vars.sh

## Delete EKS Node Group
# aws eks delete-nodegroup \
#     --cluster-name EKSCLICluster \
#     --nodegroup-name EKSCLINodeGroup

## Delete EKS Cluster
# aws eks delete-cluster \
#     --name EKSCLICluster

## Delete Subnets
# aws ec2 delete-subnet \
#     --subnet-id $privsubid
# aws ec2 delete-subnet \
#     --subnet-id $pubsubid

## Delete Route
aws ec2 delete-route \
    --route-table-id $rtid