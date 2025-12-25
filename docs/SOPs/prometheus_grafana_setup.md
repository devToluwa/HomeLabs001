# Prometheus Grafana Setup

## Step 1: Download Tools
You need three tools: prometheus, node_exporter, and grafana
you can find the file online and wget it, but i'll provide it

## prometheus
`wget https://github.com/prometheus/prometheus/releases/download/v3.8.0/prometheus-3.8.0.linux-amd64.tar.gz` - stable\
`wget https://github.com/prometheus/prometheus/releases/download/v3.9.0-rc.0/prometheus-3.9.0-rc.0.linux-amd64.tar.gz` - RC(OPTIONAL)

## node_exporter
`wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz`

## grafana
this is a bit different\
we gonna install it from a package manager
the method below is for CentOS\RHEL systems

### 1. Add Grafana repo
```
sudo tee /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=Grafana OSS
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF
```

### 2. Install Grafana
`sudo dnf -y install grafana`

### 3. Start and enable Grafana
`sudo systemctl enable --now grafana-server`

### 4. Confirm it's running
`systemctl status grafana-server`

### 5. Open firewall port in case
```
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
```

### 6. SELinux stuff too, just in case
`sudo setsebool -P httpd_can_network_connect 1`


## Step 2: Extract and Organize
### prometheus and node exporter
after downloading prometheus, extract it to a folder i guess
```
mkdir -p ~/monitoring/{tar_prometheus,tar_node_exporter}
tar -xvf prometheus-*.tar.gz -C ~/monitoring/tar_prometheus
tar -xvf node_exporter*.tar.gz -C ~/monitoring/tar_node_exporter
```


## Step 3: Run tools
```
# prometheus
cd ~/monitoring/tar_prometheus/prometheus-*/
./prometheus --config.file=prometheus.yml

# node exporter
cd ~/monitoring/tar_node_exporter/node_exporter-*/
./node_exporter
```


## Step 4: Grafana access
below is the link to acess the webportal
and the default username and password is admin admin
```
http://SERVER_IP:3000
admin/admin
```


## Step 5: Connect Prometheus → Grafana
**STUFF**
If you dont know how to access the below follow other steps below:
Data soruce, Import Dashboard
- Data source
- URL: http://<server-ip>:9090
- Import dashboard 1860


**Data Source**
- Left sidebar → click (Settings) → Data Sourcesi
OR
- Press / → type data sources → select Connections → Data sources
- Click Add data source
- Choose Prometheus
- `URL: http://localhost:9090`

**Import Dashboard**
- Left sidebar → + → Import
- Dashboard ID: 1860
- Select your Prometheus data source → **Import**
