#!/bin/bash

# EKS Cluster creation
aws eks create-cluster \
    --name EKSCLICluster \
    --role-arn $eksarn \
    --resources-vpc-config subnetIds=$pubsubid,$privsubid

aws eks wait cluster-active \
    --name EKSCLICluster

# Create nodegroup for EKS cluster * Cluster name hardcoded til i can figure out how to make a variable
aws eks create-nodegroup \
    --cluster-name EKSCLICluster \
    --nodegroup-name EKSCLINodeGroup \
    --subnets $pubsubid $privsubid \
    --node-role $eksarn \
    --scaling-config minSize=1,maxSize=2,desiredSize=1 \
    --update-config maxUnavailable=2 \
    --tags kubernetes.io/cluster/EKSCLICluster="owned"

aws eks wait nodegroup-active \
    --cluster-name EKSCLICluster \
    --nodegroup-name EKSCLINodeGroup