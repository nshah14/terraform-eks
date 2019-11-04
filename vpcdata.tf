data "aws_vpc" "vpc-gCoK8S" {
  id = "vpc-???"
}

#subnets
#retrieves a list of all subnets in a VPC with a custom tag of Name set to "gCoK8S"
data "aws_subnet_ids" "subnet-gCoK8S" {
  vpc_id = "${data.aws_vpc.selected.vpc_id}"

  tags = {
    Name = "gCo"
  }
}

data "aws_route_table" "rt-gCoK8S" {
  subnet_id = "${data.aws_subnet_ids.subnet-gCoK8S.subnet_id}"
}