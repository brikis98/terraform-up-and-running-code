#!/bin/bash

set -e

dry_run=false
if [[ "$1" == "dry-run" ]]; then
  dry_run=true
fi

function run_clean_command() {
  if [[ $dry_run == false ]]; then
    $*
  else
    echo "DRY RUN: $*"
  fi
}

regions="us-east-1 us-east-2 us-west-1 us-west-2"
# regions="$(aws ec2 describe-regions | jq -r '.Regions[].RegionName')"

for region in $regions; do
  echo "Cleaning up resources in $region..."
  for cloud9_environment in $(aws --region $region cloud9 list-environments | jq -r '.environmentIds[]'); do
    echo "Removing Cloud9 environment: $cloud9_environment"
    run_clean_command aws --region $region cloud9 delete-environment --environment-id $cloud9_environment
  done
  for autoscaler in $(aws --region $region autoscaling describe-auto-scaling-groups | jq -r '.AutoScalingGroups[].AutoScalingGroupName'); do
    echo "Removing autoscaler: $autoscaler"
    run_clean_command aws --region $region autoscaling delete-auto-scaling-group --auto-scaling-group-name $autoscaler --force-delete
  done
  for load_balancer in $(aws --region $region elbv2 describe-load-balancers | jq -r '.LoadBalancers[].LoadBalancerArn'); do
    for listener in $(aws --region $region elbv2 describe-listeners --load-balancer-arn $load_balancer | jq -r '.Listeners[].ListenerArn'); do
      echo "Removing load balancer listener: $listener"
      run_clean_command aws --region $region elbv2 delete-listener --listener-arn $listener
    done
    echo "Removing load balancer: $load_balancer"
    run_clean_command aws --region $region elbv2 delete-load-balancer --load-balancer-arn $load_balancer
  done
  for target_group in $(aws --region $region elbv2 describe-target-groups | jq -r '.TargetGroups[].TargetGroupArn'); do
    echo "Removing target group: $target_group"
    run_clean_command aws --region $region elbv2 delete-target-group --target-group-arn $target_group
  done
  for launch_configuration in $(aws --region $region autoscaling describe-launch-configurations | jq -r '.LaunchConfigurations[].LaunchConfigurationName'); do
    echo "Removing launch configuration: $launch_configuration"
    run_clean_command aws --region $region autoscaling delete-launch-configuration --launch-configuration-name $launch_configuration
  done
  for instance in $(aws --region $region ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId'); do
    echo "Removing EC2 instance: $instance"
    run_clean_command aws --region $region ec2 terminate-instances --instance-ids $instance
  done
  for key_pair in $(aws --region $region ec2 describe-key-pairs | jq -r '.KeyPairs[].KeyName'); do
    echo "Removing key pair: $key_pair"
    run_clean_command aws --region $region ec2 delete-key-pair --key-name $key_pair
  done
  for security_group in $(aws --region $region ec2 describe-security-groups | jq -r '.SecurityGroups[].GroupName'); do
    if [[ "$security_group" != "default" ]]; then
      echo "Removing security group: $security_group"
      set +e
      run_clean_command aws --region $region ec2 delete-security-group --group-name $security_group
      set -e
    fi
  done
  for dynamodb_table in $(aws --region $region dynamodb list-tables | jq -r '.TableNames[]'); do
    echo "Deleting DynamoDB table: $dynamodb_table"
    run_clean_command aws --region $region dynamodb delete-table --table-name $dynamodb_table
  done
done
