# Initializing terraform

terraform {
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

# Creating IAM role for cluster

data "aws_iam_policy_document" "ayush_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ayush_infra_iam_role" {
  name               = "ayush_infra_iam_role"
  assume_role_policy = data.aws_iam_policy_document.ayush_assume_role_policy.json
}

# Attaching required policy to role created for cluster

resource "aws_iam_policy_attachment" "ayush_policy_attachment" {
  name       = "ayush_policy_attachment"
  roles      = ["${aws_iam_role.ayush_infra_iam_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Created security group with default vpc and subnet for cluster

resource "aws_security_group" "ayush_infra_sg" {
  name        = "ayush_infra_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = "vpc-087d9a138cb75a809"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["27.7.157.183/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.7.157.183/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating cluster 

resource "aws_eks_cluster" "ayush_infra_eks_cluster" {
  name     = "ayush_infra_eks_cluster"
  role_arn = aws_iam_role.ayush_infra_iam_role.arn


  vpc_config {
    subnet_ids         = ["subnet-0d6cf0838053435a9", "subnet-0d9c79b537d591ab2", "subnet-097dcf4c27c763332", "subnet-097e8dccbf700f80b"]
    security_group_ids = ["${aws_security_group.ayush_infra_sg.id}"]
  }
}

# Creating IAM role for worker node

data "aws_iam_policy_document" "ayush_assume_role_policy_for_worker_node" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ayush_infra_iam_role_for_worker_node" {
  name               = "ayush_infra_iam_role_for_worker_node"
  assume_role_policy = data.aws_iam_policy_document.ayush_assume_role_policy_for_worker_node.json
}


# Attaching required policy to role created for worker node

resource "aws_iam_policy_attachment" "AmazonEKSWorkerNodePolicy_attachment" {
  name       = "AmazonEKSWorkerNodePolicy_attachment"
  roles      = ["${aws_iam_role.ayush_infra_iam_role_for_worker_node.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_attachment" {
  name       = "AmazonEC2ContainerRegistryReadOnly_attachment"
  roles      = ["${aws_iam_role.ayush_infra_iam_role_for_worker_node.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "AmazonEKS_CNI_Policy_attachment" {
  name       = "AmazonEKS_CNI_Policy_attachment"
  roles      = ["${aws_iam_role.ayush_infra_iam_role_for_worker_node.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# create worker node group with two nodes

resource "aws_eks_node_group" "ayush_infra_node_group" {
  cluster_name    = aws_eks_cluster.ayush_infra_eks_cluster.name
  node_group_name = "ayush_infra_node_group"
  node_role_arn   = aws_iam_role.ayush_infra_iam_role_for_worker_node.arn
  subnet_ids      = ["subnet-0d6cf0838053435a9", "subnet-0d9c79b537d591ab2", "subnet-097dcf4c27c763332", "subnet-097e8dccbf700f80b"]
  #   subnet_ids      = flatten( module.aws_vpc.private_subnets_id )

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t2.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  depends_on = [
    aws_iam_policy_attachment.AmazonEKSWorkerNodePolicy_attachment,
    aws_iam_policy_attachment.AmazonEC2ContainerRegistryReadOnly_attachment,
    aws_iam_policy_attachment.AmazonEKS_CNI_Policy_attachment,
  ]
}
