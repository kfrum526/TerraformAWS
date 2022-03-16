resource "aws_eks_cluster" "testcluster" {
  name = "testcluster"
  role_arn = aws_iam_role.eksiamtest.arn

  vpc_config {
    subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
  }
}

resource "aws_eks_node_group" "nodegrouptest" {
  cluster_name = aws_eks_cluster.testcluster.name
  node_group_name = "TestNodeGroup"
  node_role_arn = aws_iam_role.eksiamtest.arn
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]
  

  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

  update_config {
    max_unavailable = 2
  }
}

output "eks_cluster_endpoint" {
  value = "${aws_eks_cluster.testcluster.endpoint}"
}

output "eks_cluster_certificate_authority" {
  value = "${aws_eks_cluster.testcluster.certificate_authority}"
}