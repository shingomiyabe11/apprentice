#!/bin/bash

echo "パスワードマネージャーへようこそ！"
echo "サービス名を入力してください："
# サービス名をservice_name変数に代入する
read service_name

echo "ユーザー名を入力してください："
# ユーザー名をusername変数に代入する
read username

echo "パスワードを入力してください："
# -s: 入力されたパスワードを表示させない
read -s password
# ユーザーの入力をpass.txtに書き込む
echo "$service_name:$username:$password" >> pass.txt

echo "Thank you!"