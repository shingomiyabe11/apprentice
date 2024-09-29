#!/bin/bash

# 無限ループ内でユーザーにメニューを表示し、選択肢に応じて適切な処理を行う
while true; do
    echo "パスワードマネージャーへようこそ！"
    echo "終了したい場合は Exit と入力してください。"
    read -p "あなたのGnuPGキーで設定したメールアドレスを入力してください。"gpg_email
    # ユーザーからの入力を受け取り、gnu_email変数に代入する。
    # [?]演算子:変数が設定されていない場合、エラーメッセージを表示。
    gpg_email="${gpg_email:?GPGのメールアドレスを設定してください。}"
    
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
            # 空文字の場合、エラーメッセージを表示する。
            serviceName="${serviceName:?サービス名を設定してください。}"
            
            read -p "ユーザー名を入力してください: " userName
            # 空文字の場合、エラーメッセージを表示する。
            userName="${userName:?ユーザー名を設定してください。}"
            
            # -s: 入力されたパスワードを表示させない
            read -s -p "パスワードを入力してください: " password
            # 空文字の場合、エラーメッセージを表示する。
            password="${password:?パスワードを入力してください。}"
            
            # 復号化したデータを一時ファイルに保存。
            # 標準エラー出力(2)を/dev/nullに捨てる。つまり、エラーメッセージを表示しない。
            gpg -d password.gpg > password.txt 2> /dev/null
            
            # ユーザーの入力をpassword.txtファイルに書き込む。
            # [>>]リダイレクト演算子:このファイルに情報を書き込んでという意味
            echo "$serviceName:$userName:$password" >> password.txt
            
            # 入力ファイルを暗号化して出力ファイルに保存する。
            gpg -r "$gpg_email" -e -o password.gpg password.txt
            
            echo "パスワードの追加は成功しました。"
            # ;;各処理の終了を示す
            # ;;を忘れずに
            ;;
        # Get Passwordを入力した場合
        "Get Password")
            read -p "サービス名を入力してください: " serviceName
            # 復号化したデータを一時ファイルに保存。
            gpg -d password.gpg > password.txt 2> /dev/null
            # serviceNameに対応するpassをpassword.txtファイルから取得
            # cut -d: -f3: 「:」で区切られた3番目のフィールド（パスワード）を取得
            password=$(grep "^$serviceName:" password.txt | cut -d: -f3)

            # 文字列（password変数）の長さが空である場合に真（TURE）
            if [ -z "$password" ]; then
                echo "そのサービスは登録されていません。"
            else
                echo "サービス名：$serviceName"
                # サービス名に対応するユーザー名を表示
                # cut -d: -f2: 「:」で区切られた2番目のフィールド（ユーザー名）を取得。
                echo "ユーザー名：$(grep "^$serviceName:" password.txt | cut -d: -f2)"
                # サービス名に対応するパスワードを表示
                echo "パスワード：$password"
            fi
            ;;
        # Exitを入力した場合
        "Exit")
            echo "Thank you!"
            exit
            ;;
        # *)どの値にも一致しなかった場合の処理
        *)
            echo "入力が間違えています。Add Password/Get Password/Exitから入力してください。"
            ;;
    # case文の終了を示す esacを忘れずに
    # esac=caseを逆読みしてる
    esac
# whileループの終了を示す
done
    # 一時ファイルを削除する。
    rm password.txt