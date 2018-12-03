#!/usr/bin/env bash

# usage: $ curl -s https://raw.githubusercontent.com/yousan/aws_instance_list/master/aws_instans_list.sh | bash -s ap-northeast-1 default

REGION=${1:-ap-northeast-1}
PROFILE=${2:-default}

# ヘッダー行書き出し
echo -e "リージョン\tタイプ\tIDや名前\tIPアドレスや作成者\tインスタンスタイプ\t状態"

for i in ap-northeast-1 us-east-1 us-east-2 us-west-1 us-west-2 ca-central-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 ap-northeast-1 ap-northeast-2 ap-northeast-3 ap-southeast-1 ap-southeast-2 ap-south-1 sa-east-1 ; do
  echo "$i"
done


# EC2のリスト取得
aws --region ${REGION} --profile ${PROFILE} ec2 describe-instances --output text \
    --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0],PublicIpAddress,InstanceType,State.Name]' \
    | sed -e 's/^/'${REGION}$'\tEC2\t''/g'

# RDSのリスト取得
aws --region ${REGION} --profile ${PROFILE} rds describe-db-instances --output text \
    --query 'DBInstances[].[DBInstanceIdentifier,MasterUsername,DBInstanceClass,State.Name]' \
    | sed -e 's/^/'${REGION}$'\tRDS\t''/g'
