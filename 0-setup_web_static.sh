#!/usr/bin/env bash
#sets up your web servers for the eployment of web_static

#colors

blue='\e[1;34m'
green='\e[1;32m'
reset='\033[0m'

echo -e "${blue}Updating and doing some minor checks...${reset}\n"

#install nginx if not present
if [ ! -x /usr/sbin/nginx ]; then
	sudo apt-get update -y -qq && \
		sudo apt-get install -y nginx
fi

echo -e "\n${blue}Setting up some minor stuff.${reset}\n"

#create directories
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

#create index.html for test directory
echo "<h1>Welcome to Girma.tech</h1>" | sudo dd status=none of=/data/web_static/releases/test/index.html
# Create symbolic link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

#give user ownership to dictionary
sudo chown -R ubuntu:ubuntu /data/

# backup default server config file
sudo cp /etc/nginx/sites-enabled/default nginx-sites-enabled_default.backup

# Set-up the content of /data/web_static/current/ to redirect
# to domain.tech/hbnb_static
sudo sed -i '37i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

sudo service nginx restart

echo -e "${green}Completed${reset}"
