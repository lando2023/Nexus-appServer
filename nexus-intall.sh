nexus-install.sh
#!/bin/bash
# Install and start nexux as a service
# This script works well on RHEL 7 & 8 OS
# Your server must be at least 4GB of RAM
# Become the root/admin user via sudo su –
# As a good security practice, nexus is not advised to run nexus service as a root user

# 1. Create sonar
sudo useradd nexus

# 2. Grant sudo access to nexus user
sudo echo “nexus ALL=(ALL) NOPASSWD:ALL” | sudo tee /etc/sudoers.d/nexus

# 2b. Set hostname for the sonarqube server
sudo hostnamectl set-hostname nexus
hostname nexus
sudo su - nexus
# Assign password to sonar user
sudo passwd sonar
# 2c. Set password for user sonar – admin123

# 3. Enable password authentication
sudo sed -i “/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes” /etc/ssh/sshd_config
sudo service sshd restart

# 4. Install JAVA prerequisite
cd /opt
sudo yum install unzip wget git nano -y
sudo yum install java-11-openjdk-devel java-1.8.0-openjdk-devel -y

# 5. Downlaod the nexus software and extract it (unzip)
sudo wget https://download.sonatype.com/nexus/3/nexus-3.55.0-01-unix.tar.gz
sudo -xvf  nexus.tar.gz
sudo rm -rf sonarqube-7.8.zip
sudo mv /opt/nexus-3* /opt/nexus

# 6. Grant file permission for sonar user to start and manage SonarQube 
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonartype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonartype-work

# 7. Open /opt/nexus/bin/nexus.rc file and uncomment run_as_user parameter and set a
# vi into /opt/nexus/bin/nexus.rc
echo run_as_user=”nexus” > /opt/nexus/bin/nexus.rc
# vi into /opt/nexus/bin/nexus.rc
# run_as_user=”nexus”

# 8. Configure nexus to run as a service
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

# 9. Enable and start nexus service
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus

echo “end of nexus installation”
