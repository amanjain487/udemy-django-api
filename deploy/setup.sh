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

# mkdir -p $PROJECT_BASE_PATH
git clone $PROJECT_GIT_URL $PROJECT_BASE_PATH/udemy-django-api

mkdir -p $VIRTUALENV_BASE_PATH

python3 -m venv $VIRTUALENV_BASE_PATH/profiles_api_venv

$VIRTUALENV_BASE_PATH/profiles_api_venv/bin/pip install -r $PROJECT_BASE_PATH/udemy-django-api/requirements.txt

# Run migrations
cd $PROJECT_BASE_PATH/udemy-django-api/
pwd
python manage.py makemigrations
python manage.py migrate
echo "migrate done"
python manage.py collectstatic --noinput

# Setup Supervisor to run our uwsgi process.
cp $PROJECT_BASE_PATH/udemy-django-api/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
supervisorctl reread
supervisorctl update
supervisorctl restart profiles_api

# Setup nginx to make our application accessible.
cp $PROJECT_BASE_PATH/udemy-django-api/deploy/nginx_profiles_api.conf /etc/nginx/sites-available/profiles_api.conf
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/profiles_api.conf /etc/nginx/sites-enabled/profiles_api.conf
systemctl restart nginx.service

echo "DONE! :)"
