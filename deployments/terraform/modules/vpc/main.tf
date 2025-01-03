
import {
  id = "vpc-644d8b02"
  to = aws_vpc.main
}
resource "aws_vpc" "main" {
}

# TODO: デフォルトvpcのsubnet3つをimport?
# import {
#   id = "subnet-b3ae2498"
#   to = aws_subnet.ap-northeast-1d
# }
# resource "aws_subnet" "ap-northeast-1d" {
#   vpc_id            = aws_vpc.main.id
# }