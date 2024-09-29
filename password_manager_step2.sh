#!/bin/bash

# 無限ループ内でユーザーにメニューを表示し、選択肢に応じて適切な処理を行う
while true; do
    echo "パスワードマネージャーへようこそ！"
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit):"
    # ユーザーからの入力を受け取り、choice変数に代入する
    read choice

    case $choice in
        # Add Passwordを入力した場合
        "Add Password")
　　　　　　# -pオプションでメッセージ（プロンプト）を表示
　　　　　　# -p: ユーザーの入力情報を標準入力にする
            # ユーザーからの入力を受け取り、変数に代入する
            read -p "サービス名を入力してください: " serviceName
            read -p "ユーザー名を入力してください: " userName
            # -s: 入力されたパスワードを表示させない
            read -s -p "パスワードを入力してください: " password
            # 入力された情報をpasswords.txtファイルに追記する
            echo "$serviceName:$userName:$password" >> passwords.txt
            echo "パスワードの追加は成功しました。"
            # ;;を忘れずに
            ;;
        # Get Passwordを入力した場合
        "Get Password")
            read -p "サービス名を入力してください: " serviceName
            # serviceNameに対応するpassをpasswords.txtファイルから取得
　　　　　　# cut -d: -f3: 「:」で区切られた3番目のフィールド（パスワード）を取得
            password=$(grep "^$serviceName:" passwords.txt | cut -d: -f3)

　　　　　　# 文字列（password変数）の長さが空である場合に真（TURE）
            if [ -z "$password" ]; then
                echo "そのサービスは登録されていません。"
            else
                echo "サービス名：$serviceName"
                # サービス名に対応するユーザー名を表示
　　　　　　　　# cut -d: -f2: 「:」で区切られた2番目のフィールド（ユーザー名）を取得。
                echo "ユーザー名：$(grep "^$serviceName:" passwords.txt | cut -d: -f2)"
                # サービス名に対応するパスワードを表示
                echo "パスワード：$password"
            fi
            ;;
        # Exitを入力した場合
        "Exit")
            echo "Thank you!"
            exit
            ;;
        # その他の入力をした場合
        *)
            echo "入力が間違えています。Add Password/Get Password/Exitから入力してください。"
            ;;
    # case文の終了を示す esacを忘れずに
    # esac=caseを逆読みしてる
    esac
# whileループの終了を示す
done