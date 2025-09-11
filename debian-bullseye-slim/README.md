# kacpp-ja Debian日本語環境Dockerイメージ

## 概要
Debian Dockerイメージは日本語の設定がされていない。
そもそもja_JP.UTF-8のロケールすらない。またタイムゾーンのAsia/Tokyoもない。
そのため必要なパッケージをインストールローケルを作成し日本語の設定を行った。
Dockerイメージ名はkagalpandh/kacpp-ja:debian-bullseye-slimである。

## 使い方
```shell
docker image pull kagalpandh/kacpp-ja:debian-bullseye-slim
docker run -dit --name kacpp-ja kagalpandh/kacpp-ja:debian-bullseye-slim
```

## 説明
debianイメージは日本語の設定がされていない。
そもそもロケールのja_JP.UTF-8すらない。
そのため日本語の入力がさらなかったためロケールをインストール作成した。
タイムゾーンもAsia/Tokyoがないためタイムゾーン情報をインストールし設定。
その他日本語に関連するパッケージnkfとlessをインストール。

###日本語のロケールの設定
```shell
apt install -y locales
echo "ja_JP.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
#これは念の為
localedef -f UTF-8 -i ja_JP ja_JP.utf8

#ロケールの設定
export LANG=ja_JP.UTF-8
export LC_CTYPE="ja_JP.UTF-8"
export LC_NUMERIC="ja_JP.UTF-8"
export LC_TIME="ja_JP.UTF-8"
export LC_MONETARY="ja_JP.UTF-8"
export LC_MESSAGES="ja_JP.UTF-8"
# export LC_ALL=ja_JP.UTF-8
```
環境変数はENVでイメージに焼き付けてある。

### タイムゾーンの設定
```shell
apt install -y tzdata
ln -f -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
export TZ="Asia/Tokyo"
```
これもENVでイメ___ージに焼き付けている。

##構成
bashの環境変数と毎回起動して読み込むファイルbashrcの配置。
/etc/profileを読み込むようになっているがここでは/etc/rc.dの
profileに相当するのがrcprofileでbashrcに対応するのがrcsrcに変更。
/etc/profileと/etc/bashrc.bashrcそれぞれこれらファイルを読み込むように設定。

## ベースイメージ
debian:bullseye-slim

## その他
DockerHub:
[kagalpandh/kacpp-ja](https://hub.docker.com/repository/docker/kagalpandh/kacpp-ja:debian-bullseye-slim)<br />
GitHub: [karakawa88/kacpp-ja](https://github.com/karakawa88/kacpp-ja)

