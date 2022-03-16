resource "aws_iam_role" "eksiamtest" {
  name = "eksiamtest"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com",
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "eksiamtest-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eksiamtest.name
}
resource "aws_iam_role_policy_attachment" "eksiamtest-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eksiamtest.name
}
resource "aws_iam_role_policy_attachment" "eksiamtest-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eksiamtest.name
}
resource "aws_iam_role_policy_attachment" "eksiamtest-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eksiamtest.name
}

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

output "eks_clsuter_endpoint" {
  value = "${aws_eks_cluster.testcluster.endpoint}"
}

output "eks_cluster_certificate_authority" {
  value = "${aws_eks_cluster.testcluster.certificate_authority}"
}