#!/bin/bash

echo "Installing docker..."
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Running uashield as a daemon with 2000 requests. This value can be changed according to droplet size"
docker run -d --restart unless-stopped ghcr.io/opengs/uashield:0.0.x 2000 true

echo "Creating script to monitor requests via logs..."
echo "docker ps -q > containers.id
while read container
do
docker logs -t -f $container | grep --color -P " 200"
done < containers.id" >> get_log.sh

echo "Running script to see requests..."
sh get_log.sh
