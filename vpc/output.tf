output "nodes_role" {
  value = aws_iam_role.nodes.arn

}

output "demo_role" {
  value = aws_iam_role.demo.arn

}
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public" {
  value = aws_subnet.public.*.id
}

output "private" {
  value = aws_subnet.private.*.id
}