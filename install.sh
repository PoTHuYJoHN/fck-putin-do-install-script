#!/bin/bash

echo "Installing docker..."
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce

echo "Running uashield as a daemon with 2000 requests. This value can be changed according to droplet size"
docker run -d --restart unless-stopped ghcr.io/opengs/uashield:0.0.x 2000 true

echo "Creating script to monitor requests via logs..."

cat <<EOT >> get_log.sh
#!/bin/bash
docker ps -q > containers.id
while read container
do
docker logs -t -f $container | grep --color -P " 200"
done < containers.id
EOT

echo "Running script to see requests..."
sh get_log.sh
