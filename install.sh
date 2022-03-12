#!/bin/bash

echo "Installing docker..."
sudo apt-get update
apt install docker.io

echo "Running uashield as a daemon with 2000 requests. This value can be changed according to droplet size"
docker run -d --restart unless-stopped ghcr.io/opengs/uashield:0.0.x 2000 true

echo "Creating script to monitor requests via logs..."
echo "#!/bin/bash
docker ps -q > containers.id
while read container
do
docker logs -t -f $container | grep --color -P " 200"
done < containers.id" >> get_log.sh

echo "Running script to see requests..."
sh get_log.sh
