#!/bin/bash
yum install -y httpd24 php56
export AWS_DEFAULT_REGION=us-west-2
volume=`aws ec2 describe-volumes --out text | grep available | cut -f 9`
aws ec2 attach-volume --volume-id $volume --instance-id  $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --device /dev/xvdb
sleep  10 # there is some delay until the device is available
mkdir /persistent
mount /dev/xvdb /persistent
echo 0 > /tmp/instance-uptime.dat
chmod o+w /tmp/instance-uptime.dat
echo "<?php
\$total_uptime = file_get_contents('/persistent/data/total-uptime.dat', FILE_USE_INCLUDE_PATH);
\$instance_uptime = file_get_contents('/tmp/instance-uptime.dat', FILE_USE_INCLUDE_PATH);
echo \"Total uptime: \$total_uptime seconds<br>Instance uptime: \$instance_uptime seconds\"
?>" > /var/www/html/index.php
sudo chown apache:apache /var/www/html/index.php
echo "DirectoryIndex index.php" > /var/www/html/.htaccess
service httpd start
nohup /persistent/scripts/increment.sh >/dev/null 2>&1 &
