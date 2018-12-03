<img width="936" alt="Screen Shot 2018-12-01 at 0.01.15.png" src="https://qiita-image-store.s3.amazonaws.com/0/47327/1c47f2bf-dae7-9057-5d84-896bdcc46b09.png">

AWS便利ですね！re:Inventも盛り上がっているようで楽しそうです。
便利な半面AWSのインスタンス管理は大変です。
インスタンスの一覧を簡単に取得することで管理しやすくならないかなということで取得してみました。

https://github.com/yousan/aws_instance_list


```bash:aws_instans_list.sh
#!/usr/bin/env bash

# usage: $ curl -s https://raw.githubusercontent.com/yousan/aws_instance_list/master/aws_instans_list.sh | bash -s ap-northeast-1 default

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
```

上記のコードを動かすと、CSV（タブ区切り）でEC2とRDSのインスタンスのリストを取得できます。

```bash
$ bash aws_instans_list.sh
リージョン	タイプ	IDや名前	IPアドレスや作成者	インスタンスタイプ
ap-northeast-1	EC2	hoge.l2tp.org redmine	192.0.2.1	t2.micro
```

`pbcopy`に渡してGoogleスプレッドシートなどに貼ると見やすいです。

```bash
$ bash aws_instans_list.sh | pbcopy
```

<img width="716" alt="Screen Shot 2018-12-01 at 0.06.50.png" src="https://qiita-image-store.s3.amazonaws.com/0/47327/5d8394f6-761d-70a8-17d1-4732bb1499c2.png">

引数にリージョンとAWS CLIのプロファイルを渡せます。

```bash
$ bash aws_instans_list.sh ap-northeast-1 l2tp | pbcopy
```

GitHub上のコードを実行する場合には`| bash -s`で引数を渡します。

```bash
curl -s https://raw.githubusercontent.com/yousan/aws_instance_list/1bd5e0bae20de6201bf161b55b95e6059ece2f02/aws_instans_list.sh | bash -s ap-northeast-1 default | pbcopy
```

# 出ている項目
現在はインスタンス名、IPアドレス（RDSならMasterUsername）、インスタンスタイプを出しています。AWS CLIの`--query`を調整することでカラムを変更できます。

# もっとやりたいこと

1. 料金の管理をしたいのでインスタンスタイプから概算料金を出したいです。
2. リージョン決め打ちなのでそこのループを回したいです。（現在は手動でループ）

上記その他にヒントやアイディアがあれば是非教えてください！
