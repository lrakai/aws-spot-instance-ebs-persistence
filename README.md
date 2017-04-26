# aws-spot-instance-ebs-persistence
Shell scripts to demonstrate using EBS volumes for spot instance fault tolerance.

# Scenario
Spot instances on AWS can save a pretty penny.  However, spot instances can be terminated without notice, applications on spot instances should be tolerant of such unprompted faults.  In the scenario being demonstrated, a spot request set to maintain a single instance is uses an attached EBS volume to store important data that must live across spot instance terminations.  The instance simply hosts a php page that tracks the number of seconds the site is up over all instances and for the current instance.

# Script descriptions
volume.sh bootstraps the volume with persistent data and script files.

user_data.sh is the user data script to initialize the spot instance and attached the EBS volume storing the persisted data.  The instance uses an instance role with the policy in [spot-instance-policy.json](spot-instance-policy.json) attached.

# Screenshot
<img src="https://cloud.githubusercontent.com/assets/3911650/25417583/40fd729e-2a02-11e7-92ca-eee35056f080.png" alt="Screenshot" width="200">
