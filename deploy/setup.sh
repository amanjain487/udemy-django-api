#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/amanjain487/udemy-django-api.git'

PROJECT_BASE_PATH='/usr/local/apps'
VIRTUALENV_BASE_PATH='/usr/local/virtualenvs'

# Set Ubuntu Language
locale-gen en_GB.UTF-8

# Install Python, SQLite and pip
echo "Installing dependencies..."
apt-get update
apt-get install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# mkdir -p /usr/local/apps
git clone $PROJECT_GIT_URL /usr/local/apps/udemy-django-api

mkdir -p /usr/local/virtualenvs

python3 -m venv /usr/local/virtualenvs/profiles_api_venv
source /usr/local/virtualenvs/profiles_api_venv/bin/activate
/usr/local/virtualenvs/profiles_api_venv/bin/pip install -r /usr/local/apps/udemy-django-api/requirements.txt

# Run migrations
cd /usr/local/apps/udemy-django-api/
pwd
python3 manage.py makemigrations
python3 manage.py migrate
echo "migrate done"
python3 manage.py collectstatic --noinput

deactivate

# Setup Supervisor to run our uwsgi process.
cp /usr/local/apps/udemy-django-api/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
supervisorctl reread
supervisorctl update
supervisorctl restart profiles_api
echo "DONE! :)"

# Setup nginx to make our application accessible.
cp /usr/local/apps/udemy-django-api/deploy/nginx_profiles_api.conf /etc/nginx/sites-available/profiles_api.conf
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/profiles_api.conf /etc/nginx/sites-enabled/profiles_api.conf
systemctl restart nginx.service

echo "DONE! :)"
