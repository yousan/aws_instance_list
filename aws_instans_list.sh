#!/usr/bin/env bash

# usage:

REGION=${1:-ap-northeast-1}
PROFILE=${2:-default}

# ヘッダー行書き出し
echo -e "リージョン\tタイプ\tIDや名前\tIPアドレスや作成者\tインスタンスタイプ"

# EC2のリスト取得
aws --region ${REGION} --profile ${PROFILE} ec2 describe-instances --output text \
    --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0],PublicIpAddress,InstanceType]' \
    | sed -e 's/^/'${REGION}$'\tEC2\t''/g'

# RDSのリスト取得
aws --region ${REGION} --profile ${PROFILE} rds describe-db-instances --output text \
    --query 'DBInstances[].[DBInstanceIdentifier,MasterUsername,DBInstanceClass]' \
    | sed -e 's/^/'${REGION}$'\tRDS\t''/g'
