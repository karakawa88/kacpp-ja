# debianのdockerイメージには日本語設定がされていない
# debianのシェル内で日本語入力できないなどの不便なので
# 日本語設定を行ったイメージを作成する
# FROM        debian
FROM        debian:buster-slim
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
# 環境変数をイメージに焼き込む
#ロケールの設定
ENV         LANG=ja_JP.UTF-8
ENV         LC_CTYPE=ja_JP.UTF-8
ENV         LC_NUMERIC=ja_JP.UTF-8
ENV         LC_TIME=ja_JP.UTF-8
ENV         LC_MONETARY=ja_JP.UTF-8
ENV         LC_MESSAGES=ja_JP.UTF-8
ENV         LC_ALL=ja_JP.UTF-8
# タイムゾーンの設定
ENV         TZ="Asia/Tokyo"
## ロケールの環境変数を全ユーザーに設定するために/etc/profileそして
## ログイン時のみでなく全コマンド実行時に読み込むbashrcに設定する。
# ここでは/etc/rc.dにprofile, bashrcに相当するファイルがそれぞれ
# rcprofile, rcsrcがありそれを読み込む設定にする。
RUN         mkdir /etc/rc.d
COPY        rc.d/ /etc/rc.d
COPY        profile /etc
COPY        bash.bashrc /etc
# ローカルタイムもAsia/tokyoがないためtzdataパッケージを入れる。
RUN         apt update && \
            apt install -y locales tzdata && \
            # 日本語に関連するコマンドをインストール
            apt install -y nkf less && \
            # debianはja_JP.UTF-8ロケールが無いので作成する。
            echo "ja_JP.UTF-8 UTF-8" >>/etc/locale.gen && \
                locale-gen && \
                localedef -f UTF-8 -i ja_JP ja_JP.utf8 && \
                update-locale LANG=ja_JP.UTF-8 && \
            # timezoneをAsia/Tokyoに変更する
            ln -f -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
            # ユーザー毎の全コマンドに設定する.bashrcにもロケールを設定
            echo "export TZ=Asia/Tokyo" >>.bashrc && \
            echo "export LANG=ja_JP.UTF-8" >>.bashrc && \
            cp .bashrc /etc/skel && \
            # 便利なコマンドをあらかじめ入れておく
            apt install -y binutils && \
            #終了処理
            apt clean && rm -rf /var/lib/apt/lists/*
ENTRYPOINT  ["/bin/bash"]
