#!/bin/bash

# ==============================================
# SonarQube 25.x Installer for Ubuntu EC2
# ==============================================

# Exit on error
set -e

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing Java 17 ==="
sudo apt install -y openjdk-17-jdk
java -version

echo "=== Installing PostgreSQL ==="
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
psql --version

echo "=== Setting up PostgreSQL database and user ==="
sudo -i -u postgres psql <<EOF
CREATE DATABASE sonarqube;
CREATE USER sonar WITH ENCRYPTED PASSWORD 'SonarPass123';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
\c sonarqube
GRANT ALL PRIVILEGES ON SCHEMA public TO sonar;
ALTER DATABASE sonarqube OWNER TO sonar;
\q
EOF

echo "=== Installing unzip ==="
sudo apt install -y zip unzip wget

echo "=== Downloading SonarQube ==="
SONAR_VERSION="25.2.0.102705"
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
unzip sonarqube-$SONAR_VERSION.zip
sudo mv sonarqube-$SONAR_VERSION /opt/sonarqube

echo "=== Configuring SonarQube ==="
sudo sed -i "s/#sonar.jdbc.username=.*/sonar.jdbc.username=sonar/" /opt/sonarqube/conf/sonar.properties
sudo sed -i "s/#sonar.jdbc.password=.*/sonar.jdbc.password=SonarPass123/" /opt/sonarqube/conf/sonar.properties
sudo sed -i "/sonar.jdbc.password=.*/a sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube" /opt/sonarqube/conf/sonar.properties
sudo sed -i "s|#sonar.web.javaAdditionalOpts=.*|sonar.web.javaAdditionalOpts=-server|" /opt/sonarqube/conf/sonar.properties
sudo sed -i "s|#sonar.web.host=.*|sonar.web.host=0.0.0.0|" /opt/sonarqube/conf/sonar.properties

echo "=== Creating SonarQube system user ==="
sudo adduser --system --no-create-home --group --disabled-login sonar
sudo chown -R sonar:sonar /opt/sonarqube

echo "=== Setting RUN_AS_USER in sonar.sh ==="
sudo sed -i "$ a RUN_AS_USER=sonar" /opt/sonarqube/bin/linux-x86-64/sonar.sh

echo "=== Creating systemd service for SonarQube ==="
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOL
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOL

echo "=== Modifying kernel parameters ==="
sudo tee -a /etc/sysctl.conf > /dev/null <<EOL
vm.max_map_count=262144
fs.file-max=65536
EOL
sudo sysctl -p

echo "=== Setting user resource limits ==="
sudo tee /etc/security/limits.d/99-sonarqube.conf > /dev/null <<EOL
sonar   -   nofile   131072
sonar   -   nproc    8192
EOL

echo "=== Reloading systemd and starting SonarQube ==="
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube
sudo systemctl status sonarqube

echo "=== Installation complete! ==="
PUBLIC_IP=$(curl -s icanhazip.com)
echo "Access SonarQube at: http://$PUBLIC_IP:9000"
