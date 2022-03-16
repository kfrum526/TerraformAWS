#!/bin/bash

##VPC Creation
# aws ec2 create-vpc \
#     --cidr-block 11.0.0.0/16 \
#     --tag-specifications 'ResourceType=vpc,Tags=[{Key=Environment,Value="Preprod"},{Key=Name,Value="AWSCLI"}]' 
#  #   --dry-run

## Set vpc ID to variable
vpcid=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=AWSCLI --query Vpcs[].VpcId --output text)

# ## Subnet creation

# Public Subnet creation
# aws ec2 create-subnet \
#     --vpc-id $vpcid \
#     --cidr-block 11.0.1.0/24 \
#     --availability-zone us-east-1a \
#     --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value="CLIPubSubnet"}]' 
#  #   --dry-run

# # Set pub subnet to variable
pubsubid=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPubSubnet --query "Subnets[*].{ID:SubnetId}" --output text)
pubsubname=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPubSubnet --query "Subnets[*].Tags[*].Value" --output text)

# Auto Assign IPv4 Adress on launch
# aws ec2 modify-subnet-attribute --subnet $pubsubid --map-public-ip-on-launch

#  # Private Subnet creation
# aws ec2 create-subnet \
#     --vpc-id $vpcid \
#     --cidr-block 11.0.2.0/24 \
#     --availability-zone us-east-1b \
#     --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value="CLIPrivSubnet"}]' 
#  #   --dry-run

# # Set priv subnet to variable
privsubid=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPrivSubnet --query "Subnets[*].{ID:SubnetId}" --output text)
privsubname=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPrivSubnet --query "Subnets[*].Tags[*].Value" --output text)

# Auto Assign IPv4 Address on launch
# aws ec2 modify-subnet-attribute --subnet $privsubid --map-public-ip-on-launch

# ## Internet Gateway Creation
# aws ec2 create-internet-gateway \
#     --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value="CLI-IGW"}]' \
#  #   --dry-run

#  # IGW variable
igwid=$(aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=CLI-IGW --query "InternetGateways[*].{ID:InternetGatewayId}" --output text)

# Associate internet gateway with vpc
# aws ec2 attach-internet-gateway \
#     --internet-gateway-id $igwid \
#     --vpc-id $vpcid

## Route table creation
# aws ec2 create-route-table \
#     --vpc-id $vpcid \
#     --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value="CLI-RT"}]' \
# #   --dry-run

# Route Table ID Variable
rtid=$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=CLI-RT --query "RouteTables[*].{ID:RouteTableId}" --output text)

# # Route Table Association for public
# aws ec2 associate-route-table \
#     --route-table-id $rtid \
#     --subnet-id $pubsubid

# # Route Table Association for private
# aws ec2 associate-route-table \
#     --route-table-id $rtid \
#     --subnet-id $privsubid

# Route Creation
# aws ec2 create-route \
#     --route-table-id $rtid \
#     --destination-cidr-block 0.0.0.0/0 \
#     --gateway-id $igwid
# #    --dry-run

####################################################################################################################################################################################
####################################################################################################################################################################################
####################################################################################################################################################################################

## IAM role created for EKS creation JSON policy set in JSON file listed
# aws iam create-role \
#     --role-name CLIEKSIAMTest \
#     --assume-role-policy-document file://EKS_IAM_policy.json

eksarn=$(aws iam get-role --role-name clieksiamtest --query Role.Arn --output text)

## Attach correct policy to role role-name hardcoded til i can figure out how to query the pull
# aws iam attach-role-policy \
#     --role-name CLIEKSIAMTest \
#     --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

# aws iam attach-role-policy \
#     --role-name CLIEKSIAMTest \
#     --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy

# aws iam attach-role-policy \
#     --role-name CLIEKSIAMTest \
#     --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy

# aws iam attach-role-policy \
#     --role-name CLIEKSIAMTest \
#     --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

####################################################################################################################################################################################
####################################################################################################################################################################################
####################################################################################################################################################################################

# ## EKS Cluster creation
# aws eks create-cluster \
#     --name EKSCLICluster \
#     --role-arn $eksarn \
#     --resources-vpc-config subnetIds=$pubsubid,$privsubid

## Create nodegroup for EKS cluster * Cluster name hardcoded til i can figure out how to make a variable
# aws eks create-nodegroup \
#     --cluster-name EKSCLICluster \
#     --nodegroup-name EKSCLINodeGroup \
#     --subnets $pubsubid $privsubid \
#     --node-role $eksarn \
#     --scaling-config minSize=1,maxSize=2,desiredSize=1 \
#     --update-config maxUnavailable=2