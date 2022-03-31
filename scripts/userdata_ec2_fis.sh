
#!/bin/bash

instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
region=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
zone=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep availabilityZone | awk -F\" '{print $4}')

sudo echo "<h1>ID: $instanceId      Region: $region     AvalaibilityZone: $zone</h1>" >> /var/www/domain/html/index.html