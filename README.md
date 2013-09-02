SQLCollector
============

lua for mysql-proxy






http://dev.mysql.com/doc/refman/5.1/en/mysql-proxy-scripting.html
http://dev.mysql.com/doc/refman/5.5/en/mysql-proxy-scripting.html








[plugins]
admin
debug
proxy
replicant




[root@localhost mysql-proxy-0.8.3]# /usr/local/mysql-proxy-0.8.3/bin/mysql-proxy --proxy-backend-addresses=127.0.0.1:3306  --proxy-lua-script=/tmp/mysql-proxy.lua --plugins=proxy --plugins=admin --admin-username=root --admin-password=123456 --admin-lua-script=/var/www/download/mysql-proxy/mysql-proxy-0.8.3/lib/admin.lua
