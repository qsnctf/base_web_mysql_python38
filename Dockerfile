FROM python:3.8-alpine

LABEL Organization="qsnctf" Author="M0x1n <lqn@sierting.com>"

COPY files /tmp/

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.nju.edu.cn/g' /etc/apk/repositories \
    && apk update && apk add gcc build-base libffi-dev openssl-dev libev-dev tar mysql mysql-client \
    && pip install -U pip \
    && python -m pip install -U gunicorn[gevent,eventlet] \
    && mv /tmp/flag.sh /flag.sh \
    # mysql
    && mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && sh -c 'mysqld_safe &' \
    && sleep 5s \
    && mysqladmin -uroot password 'root' \
    # Fix: Update all root password \
    && mysql -uroot -proot -e "CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION; FLUSH PRIVILEGES;" \
    && mysql -uroot -proot -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('root');" \
    && mysql -uroot -proot -e "create user ping@'%' identified by 'ping';" \
    && mv /tmp/docker-entrypoint /usr/local/bin/docker-entrypoint \
    && chmod +x /usr/local/bin/docker-entrypoint

COPY app /app

EXPOSE 80

CMD ["/bin/sh", "-c", "docker-entrypoint"]