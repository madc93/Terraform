set -e
sudo yum install git-all
sudo yum install php
sudo yum install httpd
sudo git clone https://github.com/madc93/php.git /var/www/html/app
sudo service httpd restart
