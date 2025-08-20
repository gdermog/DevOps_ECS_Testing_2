resource "aws_cloudwatch_log_group" "nginxposp" {
  name = "/ecs/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http200" {
  name           = "ecs-${var.project_name}-http200"
  log_group_name = aws_cloudwatch_log_group.nginxposp.name
  pattern        = var.http200_filter_pattern   

  metric_transformation {
    name            = "Http200Count"
    namespace       = var.custom_metric_namespace     
    value           = "1"
    default_value   = "0" 
	unit            = "Count"
  }

}


# IAM Role for EC2 to write to CloudWatch
resource "aws_iam_role" "cloudwatch_role" {
  name = "${var.project_name}-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Application = var.project_name
  }
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "${var.project_name}-cloudwatch-policy"
  role = aws_iam_role.cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "${var.project_name}-cloudwatch-profile"
  role = aws_iam_role.cloudwatch_role.name
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "ecs-${aws_ecs_cluster.pospisilv_lesson8.name}-${aws_ecs_service.pospisilv_lesson8.name}"

  dashboard_body = jsonencode({
    widgets = [
      # CPU %
      {
        "type" : "metric",
        "x" : 0, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "view" : "timeSeries",
          "region" : var.aws_region,
          "title" : "ECS Service CPU %",
          "stat" : "Average",
          "stacked" : false,
          "period" : 60,
          "yAxis" : { "left" : { "min" : 0, "max" : 1 } },
          "metrics" : [
            [ "AWS/ECS", "CPUUtilization",
              "ClusterName", aws_ecs_cluster.pospisilv_lesson8.name,
              "ServiceName", aws_ecs_service.pospisilv_lesson8.name
            ]
          ]
        }
      },

      # Memory %
      {
        "type" : "metric",
        "x" : 12, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "view" : "timeSeries",
          "region" : var.aws_region,
          "title" : "ECS Service Memory %",
          "stat" : "Average",
          "stacked" : false,
          "period" : 60,
          "yAxis" : { "left" : { "min" : 0, "max" : 1 } },
          "metrics" : [
            [ "AWS/ECS", "MemoryUtilization",
              "ClusterName", aws_ecs_cluster.pospisilv_lesson8.name,
              "ServiceName", aws_ecs_service.pospisilv_lesson8.name
            ]
          ]
        }
      },

      # HTTP 200 count/min z log-metric filteru
      {
        "type" : "metric",
        "x" : 0, "y" : 6, "width" : 24, "height" : 6,
        "properties" : {
          "view" : "timeSeries",
          "region" : var.aws_region,
          "title" : "HTTP 200 (successful page views)",
          "stat" : "Sum",
          "period" : 60,
          "metrics" : [
            [ var.custom_metric_namespace, "Http200Count" ]
          ]
        }
      }
    ]
  })
}