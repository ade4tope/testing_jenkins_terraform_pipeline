resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = merge(local.tags,
  { Name = "project-15-main-eip" })
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.networking.public_subnet_1_id
  depends_on    = [aws_internet_gateway.ig]

  tags = merge(local.tags,
  { Name = "project-15-main-nat" })
}