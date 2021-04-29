resource "aws_subnet" "private_subnet" {
  count = "${length(slice(data.aws_availability_zones.azs.names, 0, 2))}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block = "${element(var.private_subnet_cidr,count.index)}"

  tags = {
    Name = "PrivateSubnet-${count.index+1}"
    Environment = "${terraform.workspace}"
  }
}
