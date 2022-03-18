#!/bin/bash

source EKS_DEL_Vars.sh

## Delete EKS Node Group
aws eks delete-nodegroup \
    --cluster-name $CLUSTERNAME \
    --nodegroup-name $NODEGROUP

aws eks wait nodegroup-deleted \
    --nodegroup-name $NODEGROUP \
    --cluster-name $CLUSTERNAME

# Delete EKS Cluster
aws eks delete-cluster \
    --name $CLUSTERNAME

aws eks wait cluster-deleted \
    --cluster-identifier $CLUSTERNAME

## Delete Subnets
# aws ec2 delete-subnet \
#     --subnet-id $privsubid
# aws ec2 delete-subnet \
#     --subnet-id $pubsubid

## Delete Route
# aws ec2 delete-route \
#     --route-table-id $rtid \
#     --destination-cidr-block 0.0.0.0/0