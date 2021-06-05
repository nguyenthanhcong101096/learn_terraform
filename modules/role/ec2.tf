resource "aws_iam_role" "ec2_ecs_agent" {
  name               = "ecs-agent"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_ecs_agent.json
}

data "aws_iam_policy_document" "ec2_ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ecs_agent" {
  role       = aws_iam_role.ec2_ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ec2_ecs_agent.name
}
