## setup prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvf prometheus
cd prometheus-2.48.1.linux-amd64/
sudo groupadd --system prometheus
sudo useradd --system -s /sbin/nologin -g prometheus prometheus
sudo mv prometheus promtool /usr/local/bin/
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus/
sudo mv consoles/ console_libraries/ prometheus.yml /etc/prometheus/
sudo cat prometheus.service > /etc/systemd/system/prometheus.service


## setup node_exporter
cd ..
tar xvf node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64/
sudo mv node_exporter /usr/local/bin/
sudo cat nodeexporter.service > /etc/systemd/system/node-exporter.service

#INSTALL GRAFANA
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt install grafana

# start all
# start prometheus
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo systemctl start prometheus

# start node-exporter
systemctl daemon-reload
systemctl enable --now node-exporter.service

# start grafana
systemctl enable --now grafana-server.service
systemctl status grafana-server.service


# print access
echo "######### ACCESS PROMETHEUS DAN GRAFANA ##############"
echo "grafana : http://ipaddress:3000 | user:admin | password:admin"
echo "prometheus : http://ipaddress:9090"
