#!/bin/bash

# # EKS Cluster creation
function EKS_Create {
    echo "Cluster Name:"
    read CLUSTERNAME
    aws eks create-cluster \
        --name $CLUSTERNAME \
        --role-arn $eksarn \
        --resources-vpc-config subnetIds=$pubsubid,$privsubid \
        >/dev/null

    #clear

    echo "Waiting for cluster to be created..."
    aws eks wait cluster-active \
        --name $CLUSTERNAME
    echo "Cluster has been successfully created..."

    #clear
}

# Create nodegroup for EKS cluster
function EKS_node {
    echo "Select from the clsuters below and type in prompt:"
    aws eks list-clusters --query clusters --output text
    echo "Cluster Name:"
    read CLUSTERNAME
    echo "New NodeGroup Name:"
    read NODEGROUP
    echo "Instance size of nodes?"
    read INSTANCESIZE
    echo "What is the maximum amount of cluster nodes you want?"
    read MAXISIZE
    echo "What is the minimum amount of cluster nodes you want?"
    read MINISIZE
    echo "What is the desired size of the cluster node"
    read DESSIZE
    echo "How many nodes will be unavailable when needing to update?"
    read UNAVAILSIZE

    clear

    aws eks create-nodegroup \
        --cluster-name $CLUSTERNAME \
        --nodegroup-name $NODEGROUP \
        --subnets $pubsubid $privsubid \
        --node-role $eksarn \
        --instance-type $INSTANCESIZE \
        --scaling-config minSize=$MINISIZE,maxSize=$MAXISIZE,desiredSize=$DESSIZE \
        --update-config maxUnavailable=$UNAVAILSIZE \
        --tags kubernetes.io/cluster/$CLUSTERNAME="owned" \
        >/dev/null

    echo "Waiting for NodeGroup to be created..."
    aws eks wait nodegroup-active \
        --cluster-name $CLUSTERNAME \
        --nodegroup-name $NODEGROUP
    echo "NodeGroup has been created successfully..."
    sleep 1
    clear
}

## Delete EKS Node Group
function NG_del {
    echo "Select from the clusters below and type in prompt:"
    aws eks list-clusters --query clusters --output text
    echo "Cluster Name (case sensitive):"
    read CLUSTERNAME
    echo "Select from the Node Groups and type in prompt:"
    aws eks list-nodegroups --cluster-name $CLUSTERNAME --query nodegroups --output text
    echo "NodeGroup Name (case sensitive):"
    read NODEGROUP

    echo "Deleting $NODEGROUP..."
    aws eks delete-nodegroup \
        --cluster-name $CLUSTERNAME \
        --nodegroup-name $NODEGROUP \
        >/dev/null

    echo "Waiting to delete $NODEGROUP..."
    aws eks wait nodegroup-deleted \
        --nodegroup-name $NODEGROUP \
        --cluster-name $CLUSTERNAME

    echo "NodeGroup has been deleted..."
    sleep 1
    clear
}


# Delete EKS Cluster
function Cluster_DEL {
    echo "Select from the list below and type in prompt:"
    aws eks list-clusters --query clusters --output text
    echo "Cluster Name:"
    read CLUSTERNAME

    echo "Deleting $CLUSTERNAME..."
    aws eks delete-cluster \
        --name $CLUSTERNAME \
        >/dev/null

    clear

    echo "Waiting to delete $CLUSTERNAME..."
    aws eks wait cluster-deleted \
        --name $CLUSTERNAME

    echo "$CLUSTERNAME has been deleted..."
    sleep 1
    clear
}

function connect {
    echo "Select from the list below and type in prompt:"
    aws eks list-clusters --query clusters --output text
    echo "Cluster Name:"
    read CLUSTERNAME
    
    echo "Connecting to $CLUSTERNAME..."
    aws sts get-caller-identity

    aws eks --region us-east-1 update-kubeconfig --name $CLUSTERNAME
}

