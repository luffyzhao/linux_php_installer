#!/bin/bash
libsPath="/root/soft/"
phpInstallPath="/usr/local/webserver/php/"
cd libs
tar jxf php-5.6.19.tar.bz2
cd php-5.6.19/
./configure --prefix=${phpInstallPath}php5.6  --with-config-file-path=${phpInstallPath}php5.6/etc --with-config-file-scan-dir=${phpInstallPath}php5.6/etc/conf.d --with-gd --with-mcrypt=/usr/local/libmcrypt --with-libxml-dir=/usr/local/libxml2 --with-jpeg-dir=/usr/local/jpeg7 --with-png-dir=/usr/local/libpng --with-freetype-dir=/usr/local/freetype2 --with-mysql=mysqlnd  --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd  --enable-fpm --disable-phar --with-fpm-user=web --with-fpm-group=web --with-pcre-regex --with-zlib --with-bz2 --enable-calendar --with-curl --enable-dba  --enable-ftp  --enable-gd-native-ttf  --with-zlib-dir  --with-mhash --enable-mbstring  --enable-xml --disable-rpath  --enable-shmop --enable-opcache --enable-sockets --enable-zip --enable-bcmath --disable-ipv6
make && make install
if [ -d "${phpInstallPath}php5.6/etc" ];then
        if [ ! -f "${phpInstallPath}php5.6/etc/php.ini-production" ];then
            cp php.ini-production ${phpInstallPath}php5.6/etc
        fi
        if [ ! -f "${phpInstallPath}php5.6/etc/php.ini-development" ];then
            cp php.ini-development ${phpInstallPath}php5.6/etc
        fi
        if [ ! -f "${phpInstallPath}php5.6/etc/php.ini" ];then
            cp ../etc/php.ini ${phpInstallPath}php5.6/etc/php.ini
        fi
        if [ ! -f "${phpInstallPath}php5.6/etc/php.ini" ];then
            cp ../etc/php-cli.ini ${phpInstallPath}php5.6/etc/php-cli.ini
        fi
        if [ ! -f "${phpInstallPath}php5.6/etc/php-fpm.conf" ];then
            cp ../etc/php-fpm.5.6.conf ${phpInstallPath}php5.6/etc/php-fpm.conf
        fi
        if [ ! -f "${phpInstallPath}php5.6/fpm.sh" ];then
            cp ../etc/fpm.5.6.sh ${phpInstallPath}php5.6/fpm.sh
        fi
        #==========================================================
        if [ -d "${phpInstallPath}php5.6/bin" ];then
            if [ ! -d "${phpInstallPath}php5.6/etc/conf.d" ];then
               mkdir ${phpInstallPath}php5.6/etc/conf.d
            fi
        fi
        cd ext/pcntl/
        ${phpInstallPath}php5.6/bin/phpize
        ./configure --with-php-config=${phpInstallPath}php5.6/bin/php-config
        make && make install
        if [ -f "${phpInstallPath}php5.6/lib/php/extensions/no-debug-non-zts-20131226/pcntl.so" ];then
            echo "[pcntl]">${phpInstallPath}php5.6/etc/conf.d/pcntl.ini
            echo "extension=pcntl.so">>${phpInstallPath}php5.6/etc/conf.d/pcntl.ini
        fi
        if [ -f "${phpInstallPath}php5.6/lib/php/extensions/no-debug-non-zts-20131226/opcache.so" ];then
            echo "[opcache]">${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.enable=1">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.memory_consumption=128">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.interned_strings_buffer=8">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.max_accelerated_files=4000">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.revalidate_freq=60">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.fast_shutdown=1">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "opcache.enable_cli=1">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            echo "zend_extension=opcache.so">>${phpInstallPath}php5.6/etc/conf.d/opcache.ini
            ${phpInstallPath}php5.6/bin/php -m
        fi
        if [ ! -f "${phpInstallPath}php5.6/bin/phpcli" ];then
            echo "#!/bin/bash">>${phpInstallPath}php5.6/bin/phpcli
            echo "${phpInstallPath}php5.6/bin/php -c ${phpInstallPath}php5.6/etc/php-cli.ini $*">>${phpInstallPath}php5.6/bin/phpcli
            chmod +x ${phpInstallPath}php5.6/bin/phpcli
        fi
        cd ../../
fi
u_exitst=`cat /etc/passwd|grep web|wc -l`
if [ ${u_exitst} -eq 0 ];then
   useradd web
fi
echo "done."
