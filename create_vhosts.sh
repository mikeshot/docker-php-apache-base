#!/bin/bash

#Symbolic links
mkdir /www/
ln -s /var/www/html /www/domains
ln -s /www/domains /home/info
ln -s /www/domains/speedorder/batch /home/info/batch
ln -s /www/domains/speedorder/include /home/info/include
ln -s /www/domains/speedorder/scripts /home/info/scripts
ln -s /www/domains/speedorder/wmbridge /home/info/wmbridge
ln -s /www/domains/symfony /home/info/symfony
ln -s /www/domains/include /home/info/include

INCLUDE_PATH='".:/usr/local/lib/php:/www/domains/speedorder/include:/www/domains"'
echo "include_path = $INCLUDE_PATH" >> /usr/local/etc/php/conf.d/999-php.ini
echo "session.save_path = /tmp" >> /usr/local/etc/php/conf.d/999-php.ini

cat <<EOF >/etc/apache2/conf-available/app.conf
<VirtualHost *:80>
    ServerName app.loc
    DocumentRoot "/www/domains"
    DirectoryIndex index.php
    Alias /sf /www/domains/symfony/data/web/sf
    SetEnv APP_ENV dev
    <Directory "/www/domains/symfony/data/web/sf">
        AllowOverride All
        Allow from All
    </Directory>
    <Directory "/www/domains">
        AllowOverride All
        Allow from All
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/speedfc.conf
<VirtualHost *:80>
    ServerName speedfc.loc
    DocumentRoot "/www/domains/www.speedfc.com/htdocs"
    ErrorLog /www/domains/www.speedfc.com/logs/error.log
    CustomLog /www/domains/www.speedfc.com/logs/access.log urchin
    AddType application/x-httpd-php .phtml .html .htm .php
    php_value max_execution_time 180
    php_flag output_buffering On
    php_flag register_globals On
    DirectoryIndex index.php index.html
    php_value include_path '/www/domains/www.speedfc.com/include:/www/domains/speedorder/include'
    SetEnv APP_ENV dev

    <Directory /www/domains/www.speedfc.com/htdocs>
        Order allow,deny
        Allow from all

        Options FollowSymLinks
        php_value auto_prepend_file "head.main_site.inc.php"
        AllowOverride All
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/handheld>
        php_value auto_prepend_file 'handheld/head.inc.php'
        php_value auto_append_file 'handheld/tail.inc.php'
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin>
        php_value auto_prepend_file "head.inc.php"
        php_value auto_append_file "tail.inc.php"
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/nohead>
        php_value auto_prepend_file "head2.inc"
        php_value auto_append_file "tail2.inc"
        php_value max_execution_time 0
        php_flag output_buffering Off
    </Directory>

    ## Several non head directorys

    <Directory /www/domains/www.speedfc.com/htdocs/admin/continuity>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/customer>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/items>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/holds>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/offer>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/order_limits>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/source>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/orders/auth>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/orders/po>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    <Directory /www/domains/www.speedfc.com/htdocs/admin/po>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    ## end of non head dir
    <Directory /www/domains/www.speedfc.com/htdocs/import>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
        php_flag output_buffering On

        AuthType Basic
        AuthName "SpeedFC"
        AuthUserFile /www/domains/www.speedfc.com/conf/htpasswd
        require valid-user
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/cccart.conf
<VirtualHost *:80>
    ServerName cccart.loc
    DocumentRoot "/www/domains/cccart/htdocs"
    DirectoryIndex index.php
    php_value include_path '/www/domains/cccart/include:/www/domains/speedorder/include'
    SetEnv APP_ENV dev

    <Directory /www/domains/cccart/htdocs>
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        AllowOverride All
    </Directory>
    <Directory /www/domains/cccart/htdocs/admin>
        php_value auto_prepend_file "head.inc.php"
        php_value auto_append_file "tail.inc.php"
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/dressbarn.conf
<VirtualHost *:80>
    ServerName dressbarn.loc
    DocumentRoot "/www/domains/dressbarn/web"
    DirectoryIndex index.php
    php_value include_path '/www/domains/speedorder/include'
    SetEnv APP_ENV dev

    Alias /sf /www/domains/symfony/data/web/sf
    Alias /items /www/items
    Alias /assets /www/assets/DRESS

    <Directory "/www/domains/symfony/data/web/sf">
        AllowOverride All
        order allow,deny
        Allow from All
    </Directory>

    <Directory "/www/domains/dressbarn/web">
        AllowOverride All
        order allow,deny
        Allow from All
    </Directory>

    ErrorLog /www/domains/dressbarn/log/httpd_error.log
    CustomLog /www/domains/dressbarn/log/httpd_access.log urchin

</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/symfony.conf
<VirtualHost *:80>
    ServerName symfony.loc
    DocumentRoot "/www/domains/symfonyApp/helloWorld/web"
    DirectoryIndex index.php
    <Directory /www/domains/symfonyApp/helloWorld/web>
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/asignaciones.conf
<VirtualHost *:80>
    ServerName asignaciones.loc
    DocumentRoot "/www/domains/symfonyApp/asignaciones/web"
    DirectoryIndex index.php
    <Directory /www/domains/symfonyApp/asignaciones/web>
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
a2enconf app.conf
a2enconf speedfc.conf
a2enconf cccart.conf
a2enconf dressbarn.conf
a2enconf symfony.conf
a2enconf asignaciones.conf

service apache2 restart

