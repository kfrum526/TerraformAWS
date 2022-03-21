#!/bin/bash

source EKS_Vars.sh

# # EKS Cluster creation
aws eks create-cluster \
    --name $CLUSTERNAME \
    --role-arn $eksarn \
    --resources-vpc-config subnetIds=$pubsubid,$privsubid

aws eks wait cluster-active \
    --name $CLUSTERNAME

# Create nodegroup for EKS cluster * Cluster name hardcoded til i can figure out how to make a variable
aws eks create-nodegroup \
    --cluster-name $CLUSTERNAME \
    --nodegroup-name $NODEGROUP \
    --subnets $pubsubid $privsubid \
    --node-role $eksarn \
    --instance-type $INSTANCESIZE \
    --scaling-config minSize=$MINISIZE,maxSize=$MAXISIZE,desiredSize=$DESSIZE \
    --update-config maxUnavailable=$UNAVAILSIZE \
    --tags kubernetes.io/cluster/$CLUSTERNAME="owned"

aws eks wait nodegroup-active \
    --cluster-name $CLUSTERNAME \
    --nodegroup-name $NODEGROUP