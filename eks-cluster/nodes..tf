#data block
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}

/*
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.mode.name
  node_group_name = "private-nodes"
  node_role_arn   = data.terraform_remote_state.network.outputs.nodes_role

  subnet_ids = [
    data.terraform_remote_state.network.outputs.private[0],
    data.terraform_remote_state.network.outputs.private[1]

  ]

  instance_types = ["t2.micro"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "devops"
  }

  tags = {

    "k8s.io/cluster-autoscaler/mode"    = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"

    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/mode"      = "owned"

  }
}

*/
resource "aws_eks_node_group" "public-nodes" {
  cluster_name    = aws_eks_cluster.mode.name
  node_group_name = "public-nodes"
  node_role_arn   = data.terraform_remote_state.network.outputs.nodes_role

  subnet_ids = [
    data.terraform_remote_state.network.outputs.public[0],
    data.terraform_remote_state.network.outputs.public[1]

  ]

  instance_types = ["t2.medium"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "devops"
  }

  tags = {

    "k8s.io/cluster-autoscaler/demo"    = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"

    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/mode"      = "owned"

  }
}
