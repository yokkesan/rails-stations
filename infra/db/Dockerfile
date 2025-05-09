FROM mysql:8.4.1-oraclelinux9

# タイムゾーン設定（microdnf に変更）
ENV TZ=Asia/Tokyo
RUN microdnf install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo "Asia/Tokyo" > /etc/timezone && \
    microdnf clean all

# MySQL 設定ファイルを適切にコピー
COPY infra/db/conf/my.cnf /etc/my.cnf

EXPOSE 3306