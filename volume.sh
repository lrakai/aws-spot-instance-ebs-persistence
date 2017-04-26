# Assumes 1GB ebs volume device is on /dev/sdb when the volume is selected in the AWS console instance launch configuration
lsblk # should reveal xvdb
sudo file -s /dev/xvdb
sudo mkfs -t ext4 /dev/xvdb
sudo mkdir /persistent
sudo chmod o+w /persistent
sudo mount /dev/xvdb /persistent
sudo rmdir /persistent/lost+found/
sudo mkdir /persistent/data
sudo mkdir /persistent/scripts
cd data
touch total-uptime.dat
chmod o+w total-uptime.dat
echo 0 > total-uptime.dat
cd ../scripts
sudo sh -c 'echo '"'"'#/bin/bash
while true
do
        response=`curl -s localhost`
        if [[ -n $response ]] ; then
                total_uptime=`cat /persistent/data/total-uptime.dat 2>/dev/null`
                total_uptime=$((total_uptime+1))
                echo $total_uptime > /persistent/data/total-uptime.dat
                instance_uptime=`cat /tmp/instance-uptime.dat 2>/dev/null`
                instance_uptime=$((instance_uptime+1))
                echo $instance_uptime > /tmp/instance-uptime.dat
        fi
        sleep 1
done'"'"' > increment.sh'
sudo chmod o+x increment.sh
