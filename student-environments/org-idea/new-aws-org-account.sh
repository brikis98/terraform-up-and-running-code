#!/bin/bash
function usage
{
    echo "usage: organization_new_acc.sh [-h] --account_name ACCOUNT_NAME
                                      --account_email ACCOUNT_EMAIL
                                      --cl_profile_name CLI_PROFILE_NAME
                                      [--ou_name ORGANIZATION_UNIT_NAME]
                                      [--region AWS_REGION]"
}

newAccName=""
newAccEmail=""
newProfile=""
roleName="OrganizationAccountAccessRole"
destinationOUname=""
region="us-east-1"

while [ "$1" != "" ]; do
    case $1 in
        -n | --account_name )   shift
                                newAccName=$1
                                ;;
        -e | --account_email )  shift
                                newAccEmail=$1
                                ;;
        -p | --cl_profile_name ) shift
                                newProfile=$1
                                ;;
        -o | --ou_name )        shift
                                destinationOUname=$1
                                ;;
        -r | --region )        shift
                                region=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
    shift
done

if [ "$newAccName" = "" ] || [ "$newAccEmail" = "" ] || [ "$newProfile" = "" ]
then
  usage
  exit
fi

if aws organizations list-accounts --query 'Accounts[?Name==`'"$newAccName"'`]' | grep "$newAccName" &>/dev/null; then
  printf "Account $newAccName already exists, exiting\n"
  exit
fi

printf "Create New Account\n"
ReqID=$(aws organizations create-account --email $newAccEmail --account-name "$newAccName" --role-name $roleName \
--query 'CreateAccountStatus.[Id]' \
--output text)

printf "Waiting for New Account ..."
orgStat=$(aws organizations describe-create-account-status --create-account-request-id $ReqID \
--query 'CreateAccountStatus.[State]' \
--output text)

while [ $orgStat != "SUCCEEDED" ]
do
  if [ $orgStat = "FAILED" ]
  then
    printf "\nAccount Failed to Create\n"
    exit 1
  fi
  printf "."
  sleep 10
  orgStat=$(aws organizations describe-create-account-status --create-account-request-id $ReqID \
  --query 'CreateAccountStatus.[State]' \
  --output text)
done

accID=$(aws organizations describe-create-account-status --create-account-request-id $ReqID \
--query 'CreateAccountStatus.[AccountId]' \
--output text)

accARN="arn:aws:iam::$accID:role/$roleName"

printf "\nCreate New CLI Profile\n"
aws configure set region $region --profile $newProfile
aws configure set role_arn $accARN --profile $newProfile
aws configure set source_profile default --profile $newProfile

cfcntr=0
printf "Waiting for CF Service ..."
aws cloudformation list-stacks --profile $newProfile > /dev/null 2>&1
actOut=$?
while [[ $actOut -ne 0 && $cfcntr -le 10 ]]
do
  sleep 5
  aws cloudformation list-stacks --profile $newProfile > /dev/null 2>&1
  actOut=$?
  if [ $actOut -eq 0 ]
  then
    break
  fi
  printf "."
  cfcntr=$[$cfcntr +1]
done

if [ $cfcntr -gt 10 ]
then
  printf "\nCF Service not available\n"
  exit 1
fi

printf "\nCreate VPC Under New Account\n"
aws cloudformation create-stack --stack-name VPC --template-body file://CF-VPC.json --profile $newProfile > /dev/null 2>&1
if [ $? -ne 0 ]
then
  printf "CF VPC Stack Failed to Create\n"
  exit 1
fi

printf "Waiting for CF Stack to Finish ..."
cfStat=$(aws cloudformation describe-stacks --stack-name VPC --profile $newProfile --query 'Stacks[0].[StackStatus]' --output text)
while [ $cfStat != "CREATE_COMPLETE" ]
do
  sleep 5
  printf "."
  cfStat=$(aws cloudformation describe-stacks --stack-name VPC --profile $newProfile --query 'Stacks[0].[StackStatus]' --output text)
  if [ $cfStat = "CREATE_FAILED" ]
  then
    printf "\nVPC Failed to Create\n"
    exit 1
  fi
done
printf "\nVPC Created\n"

printf "Create Role and Policy\n"
aws cloudformation create-stack --stack-name Roles --template-body file://CF-IAM.json --capabilities CAPABILITY_NAMED_IAM --profile $newProfile > /dev/null 2>&1
cfStat=$(aws cloudformation describe-stacks --stack-name Roles --profile $newProfile --query 'Stacks[0].[StackStatus]' --output text)
while [ $cfStat != "CREATE_COMPLETE" ]
do
  sleep 5
  printf "."
  cfStat=$(aws cloudformation describe-stacks --stack-name Roles --profile $newProfile --query 'Stacks[0].[StackStatus]' --output text)
  if [ $cfStat = "CREATE_FAILED" ]
  then
    printf "\Role Failed to Create\n"
    exit 1
  fi
done
printf "\Role Created\n"

printf "Create Configure Rule\n"
configRole=arn:aws:iam::$accID:role/service-role/config-rule-role

aws configservice put-configuration-recorder --configuration-recorder name=default,roleARN=$configRole --recording-group allSupported=true,includeGlobalResourceTypes=true --profile $newProfile > /dev/null 2>&1
aws configservice put-config-rule --config-rule file://CF-ConfigRules.json --profile $newProfile > /dev/null 2>&1

if [ "$destinationOUname" != "" ]
then
  printf "Moving New Account to OU\n"
  rootOU=$(aws organizations list-roots --query 'Roots[0].[Id]' --output text)
  destOU=$(aws organizations list-organizational-units-for-parent --parent-id $rootOU --query 'OrganizationalUnits[?Name==`'$destinationOUname'`].[Id]' --output text)

  aws organizations move-account --account-id $accID --source-parent-id $rootOU --destination-parent-id $destOU > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    printf "Moving Account Failed\n"
  fi
fi
