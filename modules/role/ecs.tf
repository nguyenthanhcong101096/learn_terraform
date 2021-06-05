resource "aws_iam_role" "ecs_role" {
  name                = "ecs-role"
  assume_role_policy  = "${data.aws_iam_policy_document.ecs_document.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
    role       = aws_iam_role.ecs_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
