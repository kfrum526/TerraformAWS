resource "aws_iam_role" "eksiamtest" {
  name = "eksiamtest"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}


resource "aws_eks_cluster" "testcluster" {
  name = "testcluster"
  role_arn = aws_iam_role.eksiamtest.arn

  vpc_config {
    subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
  }
}