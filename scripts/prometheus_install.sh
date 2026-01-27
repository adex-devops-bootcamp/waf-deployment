#!/bin/bash
set -e

#----------------------------
# Update system
#----------------------------
echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y

#----------------------------
# Download and extract Prometheus
#----------------------------
echo "Downloading Prometheus 3.5.1..."
cd /tmp
wget -q https://github.com/prometheus/prometheus/releases/download/v3.5.1/prometheus-3.5.1.linux-amd64.tar.gz

echo "Extracting Prometheus..."
tar xvf prometheus-3.5.1.linux-amd64.tar.gz

cd prometheus-3.5.1.linux-amd64

#----------------------------
# Create config and data directories
#----------------------------
echo "Creating directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

#----------------------------
# Move binaries and config
#----------------------------
echo "Installing binaries..."
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# Verify versions
echo "Verifying installation..."
prometheus --version
promtool --version

#----------------------------
# Create Prometheus system group and user
#----------------------------
echo "Creating Prometheus user and group..."
sudo groupadd --system prometheus || true
sudo useradd -s /sbin/nologin --system -g prometheus prometheus || true

#----------------------------
# Set permissions
#----------------------------
echo "Setting ownership and permissions..."
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo chmod -R 775 /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

#----------------------------
# Create systemd service
#----------------------------
echo "Creating systemd service..."
sudo bash -c "cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=always
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file=/etc/prometheus/prometheus.yml \\
    --storage.tsdb.path=/var/lib/prometheus/ \\
    --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF"

#----------------------------
# Start Prometheus service
#----------------------------
echo "Starting Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

#----------------------------
# Show access URL
#----------------------------
PUBLIC_IP=$(curl -s icanhazip.com)
echo "Prometheus is running! Access it at: http://$PUBLIC_IP:9090"
