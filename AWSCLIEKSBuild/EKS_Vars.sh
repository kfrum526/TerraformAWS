## Set vpc ID to variable
vpcid=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=AWSCLI --query Vpcs[].VpcId --output text)

# # Set pub subnet to variable
pubsubid=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPubSubnet --query "Subnets[*].{ID:SubnetId}" --output text)
pubsubname=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPubSubnet --query "Subnets[*].Tags[*].Value" --output text)

# # Set priv subnet to variable
privsubid=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPrivSubnet --query "Subnets[*].{ID:SubnetId}" --output text)
privsubname=$(aws ec2 describe-subnets --filters Name=tag:Name,Values=CLIPrivSubnet --query "Subnets[*].Tags[*].Value" --output text)

#  # IGW variable
igwid=$(aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=CLI-IGW --query "InternetGateways[*].{ID:InternetGatewayId}" --output text)

# Route Table ID Variable
rtid=$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=CLI-RT --query "RouteTables[*].{ID:RouteTableId}" --output text)

# EKS ARN variable
eksarn=$(aws iam get-role --role-name clieksiamtest --query Role.Arn --output text)

