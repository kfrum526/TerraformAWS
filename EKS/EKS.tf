data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main"] 
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["Private Subnet B"]
  }
  vpc_id = data.aws_vpc.main_vpc.id
}

data "aws_subnet" "private_c" {
  filter {
    name   = "tag:Name"
    values = ["Private Subnet C"]
  }
  vpc_id = data.aws_vpc.main_vpc.id
}

resource "aws_eks_cluster" "testcluster" {
  name = "testcluster"
  role_arn = aws_iam_role.eksiam.arn

  vpc_config {
    subnet_ids = [data.aws_subnet.private.id, data.aws_subnet.private_c.id]
  }
}

resource "aws_eks_node_group" "nodegrouptest" {
  cluster_name = aws_eks_cluster.testcluster.name
  node_group_name = "NodeGroup"
  node_role_arn = aws_iam_role.eksiam.arn
  subnet_ids = [data.aws_subnet.private.id, data.aws_subnet.private_c.id]
  

  scaling_config {
    desired_size = 1
    max_size = 3
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }
}

output "eks_cluster_endpoint" {
  value = "${aws_eks_cluster.testcluster.endpoint}"
}

output "eks_cluster_certificate_authority" {
  value = "${aws_eks_cluster.testcluster.certificate_authority}"
}