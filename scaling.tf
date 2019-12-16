### frontend ###

# scaling up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.asg_scale_up}"
  adjustment_type        = "${var.asg_scale_up_adjustment_type}"
  policy_type            = "${var.asg_scale_up_policy_type}"
  scaling_adjustment     = var.asg_scale_up_scaling_adjustment
  cooldown               = var.asg_scale_up_cooldown
  autoscaling_group_name = "${aws_autoscaling_group.asg_frontend.name}"
}
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.cw_alarm_cpu_high}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"

  period             = var.cw_statistic_period
  evaluation_periods = var.cw_number_of_periods
  statistic          = var.cw_statistic_type
  threshold          = var.cw_cpu_high_max_threshold

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_frontend.name}"
  }

  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
  alarm_description = "Scale up when the CPU usage is higher than ${var.cw_cpu_high_max_threshold} during ${var.cw_statistic_period} seconds."
}

# scaling down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.asg_scale_down}"
  scaling_adjustment     = "${var.asg_scale_down_scaling_adjustment}"
  adjustment_type        = "${var.asg_scale_down_adjustment_type}"
  policy_type            = "${var.asg_scale_down_policy_type}"
  cooldown               = var.asg_scale_down_cooldown
  autoscaling_group_name = "${aws_autoscaling_group.asg_frontend.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.cw_alarm_cpu_low}"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"

  period             = var.cw_statistic_period
  evaluation_periods = var.cw_number_of_periods
  statistic          = var.cw_statistic_type
  threshold          = var.cw_cpu_low_min_threshold

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_frontend.name}"
  }

  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
  alarm_description = "Scale down when the CPU usage is lower than ${var.cw_cpu_low_min_threshold} during ${var.cw_statistic_period} seconds."
}


### backend ###