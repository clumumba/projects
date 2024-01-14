resource "aws_eks_cluster" "mode" {
  name     = "mode"
  role_arn = data.terraform_remote_state.network.outputs.demo_role

  #role_arn = aws_iam_role.demo.demo_role

  vpc_config {
    subnet_ids = [
      data.terraform_remote_state.network.outputs.private[0],
      data.terraform_remote_state.network.outputs.private[1],
      data.terraform_remote_state.network.outputs.public[0],
      data.terraform_remote_state.network.outputs.public[1]

    ]
  }
}