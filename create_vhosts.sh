#!/bin/bash

#Symbolic links
mkdir /www/
ln -s /var/www/html /www/domains
ln -s /var/www/html /home/info
ln -s /var/www/html/speedorder/batch /home/info/batch
ln -s /var/www/html/speedorder/include /home/info/include
ln -s /var/www/html/speedorder/scripts /home/info/scripts
ln -s /var/www/html/speedorder/wmbridge /home/info/wmbridge
ln -s /var/www/html/symfony /home/info/symfony
ln -s /var/www/html/include /home/info/include

INCLUDE_PATH='".:/usr/local/lib/php:/var/www/html/speedorder/include:/var/www/html"'
echo "include_path = $INCLUDE_PATH" >> /usr/local/etc/php/conf.d/999-php.ini
echo "session.save_path = /tmp" >> /usr/local/etc/php/conf.d/999-php.ini

cat <<EOF >/etc/apache2/conf-available/app.conf
<VirtualHost *:80>
    ServerName app.loc
    DocumentRoot "/var/www/html"
    DirectoryIndex index.php
    Alias /sf /var/www/html/symfony/data/web/sf
    SetEnv APP_ENV dev
    <Directory "/var/www/html/symfony/data/web/sf">
        AllowOverride All
        Allow from All
    </Directory>
    <Directory "/var/www/html">
        AllowOverride All
        Allow from All
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/speedfc.conf
<VirtualHost *:80>
    ServerName speedfc.loc
    DocumentRoot "/var/www/html/www.speedfc.com/htdocs"
    ErrorLog /var/www/html/www.speedfc.com/logs/error.log
    CustomLog /var/www/html/www.speedfc.com/logs/access.log urchin
    AddType application/x-httpd-php .phtml .html .htm .php
    php_value max_execution_time 180
    php_flag output_buffering On
    php_flag register_globals On
    DirectoryIndex index.php index.html
    php_value include_path '/var/www/html/www.speedfc.com/include:/var/www/html/speedorder/include'
    SetEnv APP_ENV dev

    <Directory /var/www/html/www.speedfc.com/htdocs>
        Order allow,deny
        Allow from all

        Options FollowSymLinks
        php_value auto_prepend_file "head.main_site.inc.php"
        AllowOverride All
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/handheld>
        php_value auto_prepend_file 'handheld/head.inc.php'
        php_value auto_append_file 'handheld/tail.inc.php'
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin>
        php_value auto_prepend_file "head.inc.php"
        php_value auto_append_file "tail.inc.php"
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/nohead>
        php_value auto_prepend_file "head2.inc"
        php_value auto_append_file "tail2.inc"
        php_value max_execution_time 0
        php_flag output_buffering Off
    </Directory>

    ## Several non head directorys

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/continuity>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/customer>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/items>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/holds>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/offer>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/order_limits>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/source>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/orders/auth>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/orders/po>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    <Directory /var/www/html/www.speedfc.com/htdocs/admin/po>
        php_value auto_prepend_file "blank.inc"
    </Directory>

    ## end of non head dir
    <Directory /var/www/html/www.speedfc.com/htdocs/import>
        php_value auto_prepend_file "blank.inc"
        php_flag register_globals Off
        php_flag output_buffering On

        AuthType Basic
        AuthName "SpeedFC"
        AuthUserFile /var/www/html/www.speedfc.com/conf/htpasswd
        require valid-user
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/cccart.conf
<VirtualHost *:80>
    ServerName cccart.loc
    DocumentRoot "/var/www/html/cccart/htdocs"
    DirectoryIndex index.php
    php_value include_path '/var/www/html/cccart/include:/var/www/html/speedorder/include'
    SetEnv APP_ENV dev

    <Directory /var/www/html/cccart/htdocs>
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        AllowOverride All
    </Directory>
    <Directory /var/www/html/cccart/htdocs/admin>
        php_value auto_prepend_file "head.inc.php"
        php_value auto_append_file "tail.inc.php"
    </Directory>
</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/dressbarn.conf
<VirtualHost *:80>
    ServerName dressbarn.loc
    DocumentRoot "/var/www/html/dressbarn/web"
    DirectoryIndex index.php
    php_value include_path '/var/www/html/speedorder/include'
    SetEnv APP_ENV dev

    Alias /sf /var/www/html/symfony/data/web/sf
    Alias /items /www/items
    Alias /assets /www/assets/DRESS

    <Directory "/var/www/html/symfony/data/web/sf">
        AllowOverride All
        order allow,deny
        Allow from All
    </Directory>

    <Directory "/var/www/html/dressbarn/web">
        AllowOverride All
        order allow,deny
        Allow from All
    </Directory>

    ErrorLog /var/www/html/dressbarn/log/httpd_error.log
    CustomLog /var/www/html/dressbarn/log/httpd_access.log urchin

</VirtualHost>
EOF
cat <<EOF >/etc/apache2/conf-available/symfony.conf
<VirtualHost *:80>
    ServerName symfony.loc
    DocumentRoot "/var/www/html/symfonyApp/helloWorld/web"
    DirectoryIndex index.php
    <Directory /var/www/html/symfonyApp/helloWorld/web>
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
    DocumentRoot "/var/www/html/symfonyApp/asignaciones/web"
    DirectoryIndex index.php
    <Directory /var/www/html/symfonyApp/asignaciones/web>
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

