resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address

  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  iam_instance_profile = var.iam_instance_profile

  monitoring = var.enable_monitoring

  ebs_optimized = var.ebs_optimized

  source_dest_check = var.source_dest_check

  disable_api_termination = var.disable_api_termination
  disable_api_stop        = var.disable_api_stop

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  placement_group = var.placement_group
  tenancy         = var.tenancy
  host_id         = var.host_id

  cpu_options {
    core_count       = var.cpu_core_count
    threads_per_core = var.cpu_threads_per_core
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_instance_tags
  }

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = var.root_volume_iops
    throughput            = var.root_volume_throughput
    delete_on_termination = var.root_volume_delete_on_termination
    encrypted             = var.root_volume_encrypted
    kms_key_id            = var.root_volume_kms_key_id
    tags                  = merge(var.volume_tags, { Name = "${var.name}-root" })
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = lookup(ebs_block_device.value, "volume_type", "gp3")
      volume_size           = lookup(ebs_block_device.value, "volume_size", 20)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
      encrypted             = lookup(ebs_block_device.value, "encrypted", true)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      tags                  = merge(var.volume_tags, lookup(ebs_block_device.value, "tags", {}))
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_devices
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  enclave_options {
    enabled = var.enclave_enabled
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  volume_tags = var.volume_tags

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

resource "aws_eip" "this" {
  count    = var.create_eip ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-eip"
    }
  )

  depends_on = [aws_instance.this]
}

resource "aws_eip_association" "this" {
  count         = var.eip_allocation_id != null ? 1 : 0
  instance_id   = aws_instance.this.id
  allocation_id = var.eip_allocation_id

  depends_on = [aws_instance.this]
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = var.create_cpu_alarm ? 1 : 0
  alarm_name          = "${var.name}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_alarm_period
  statistic           = var.cpu_alarm_statistic
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = var.cpu_alarm_actions

  dimensions = {
    InstanceId = aws_instance.this.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "status_check" {
  count               = var.create_status_check_alarm ? 1 : 0
  alarm_name          = "${var.name}-status-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.status_check_alarm_evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = var.status_check_alarm_period
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This metric monitors EC2 instance status checks"
  alarm_actions       = var.status_check_alarm_actions

  dimensions = {
    InstanceId = aws_instance.this.id
  }

  tags = var.tags
}
