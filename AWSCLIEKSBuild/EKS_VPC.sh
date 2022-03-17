#!/bin/bash

source EKS_Vars.sh

##VPC Creation
# aws ec2 create-vpc \
#     --cidr-block 11.0.0.0/16 \
#     --tag-specifications 'ResourceType=vpc,Tags=[{Key=Environment,Value="Preprod"},{Key=Name,Value="AWSCLI"}]' 
#  #   --dry-run

# ## Subnet creation

# Public Subnet creation
# aws ec2 create-subnet \
#     --vpc-id $vpcid \
#     --cidr-block 11.0.1.0/24 \
#     --availability-zone us-east-1a \
#     --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value="CLIPubSubnet"},{Key=kubernetes.io/cluster/EKSCLICluster,Value="shared"}]' 
#  #   --dry-run

# Auto Assign IPv4 Adress on launch
# aws ec2 modify-subnet-attribute --subnet $pubsubid --map-public-ip-on-launch

#  # Private Subnet creation
# aws ec2 create-subnet \
#     --vpc-id $vpcid \
#     --cidr-block 11.0.2.0/24 \
#     --availability-zone us-east-1b \
#     --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value="CLIPrivSubnet"},{Key=kubernetes.io/cluster/EKSCLICluster,Value="shared"}]' 
#  #   --dry-run

# Auto Assign IPv4 Address on launch
# 
# ## Internet Gateway Creation
# aws ec2 create-internet-gateway \
#     --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value="CLI-IGW"}]' \
#  #   --dry-run


# Associate internet gateway with vpc
# aws ec2 attach-internet-gateway \
#     --internet-gateway-id $igwid \
#     --vpc-id $vpcid

## Route table creation
# aws ec2 create-route-table \
#     --vpc-id $vpcid \
#     --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value="CLI-RT"}]' \
# #   --dry-run

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

