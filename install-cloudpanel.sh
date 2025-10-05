Script skeleton (what it must do):

#!/usr/bin/env bash
set -euo pipefail
# 1) apt update && install prerequisites (curl, wget, gnupg)
# 2) create swap if needed
# 3) install Docker / required packages if CloudPanel requires them
# 4) download/execute CloudPanel installer (official steps)
# 5) configure firewall (ufw allow 80,443,22)
# 6) obtain SSL cert (certbot) for domain if provided
# 7) print admin URL and any API keys


Commands commonly used inside script:

sudo apt update && sudo apt install -y curl wget git unzip
# run CloudPanel official installer (replace with official command)
# e.g. wget -qO- https://installer.cloudpanel.io/ce/v2/install.sh | sudo bash


Post-install checks:

systemctl status nginx
ss -tulnp | grep nginx


Logging: redirect script output to /var/log/cloudpanel_install.log.

Tip: add idempotence: the script should check if CloudPanel is already installed and skip or update accordingly.

C — provision/provision-scripts/install fossbilling.sh

Script skeleton:

#!/usr/bin/env bash
set -euo pipefail
# 1) install LEMP: nginx, php-fpm, mariadb/mysql, php extensions, composer
# 2) create DB and DB user
# 3) clone FOSSBilling into /var/www/fossbilling
# 4) copy sample .env and replace DB credentials
# 5) composer install --no-dev
# 6) set file permissions (www-data:www-data)
# 7) configure nginx site and reload
# 8) run migrations / seed admin user (per FOSSBilling docs)


Example DB commands (MariaDB):

sudo mysql -e "CREATE DATABASE fossbilling CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'foss'@'localhost' IDENTIFIED BY 'strong_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON fossbilling.* TO 'foss'@'localhost'; FLUSH PRIVILEGES;"


Example app setup:

git clone https://github.com/fossbilling/fossbilling.git /var/www/fossbilling
cd /var/www/fossbilling
cp .env.example .env
# update .env DB_ variables
composer install --no-dev --optimize-autoloader
php artisan migrate --seed    # if FOSSBilling uses artisan
sudo chown -R www-data:www-data /var/www/fossbilling


Nginx config: copy a templated site config into /etc/nginx/sites-available/ and symlink it; nginx -t then systemctl reload nginx.

Troubleshoot: check PHP-FPM logs (/var/log/php*-fpm.log), nginx error logs, and database connectivity.
