#!/usr/bin/env bash

# ヘッダー行書き出し
echo -e "ユーザ名\t作成日\tパスワード最終使用日"
aws iam list-users --output text --query 'Users[].[UserName,CreateDate,PasswordLastUsed]'

