resource "aws_internet_gateway" "ig" {
  vpc_id = module.networking.vpc_id

  tags = merge(local.tags,
  { Name = "project-15-main-IG" })
}

