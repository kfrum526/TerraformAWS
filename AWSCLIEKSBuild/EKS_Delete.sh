#!/bin/bash


source EKS_DEL_Var.sh

## Delete EKS Node Group
aws eks delete-nodegroup \
    --cluster-name $CLUSTERNAME \
    --nodegroup-name $NODEGROUP \
    >/dev/null

echo "Waiting to delete NodeGroup"
aws eks wait nodegroup-deleted \
    --nodegroup-name $NODEGROUP \
    --cluster-name $CLUSTERNAME

echo "NodeGroup has been deleted"

# Delete EKS Cluster
aws eks delete-cluster \
    --name $CLUSTERNAME \
    >/dev/null

echo "Waiting to delete Cluster"
aws eks wait cluster-deleted \
    --cluster-identifier $CLUSTERNAME

echo "Cluster has been deleted"

## Delete Subnets
# aws ec2 delete-subnet \
#     --subnet-id $privsubid
# aws ec2 delete-subnet \
#     --subnet-id $pubsubid

## Delete Route
# aws ec2 delete-route \
#     --route-table-id $rtid \
#     --destination-cidr-block 0.0.0.0/0