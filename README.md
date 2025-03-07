Use Grafana Alloy to send system logs to Loki.

This is the continuation of https://github.com/felixhummel/deploy-promtail
since promtail was deprecated (EOL: 2026-03-02) [^1] [^2].

[^1]: https://grafana.com/docs/loki/latest/send-data/promtail/
[^2]: https://grafana.com/docs/loki/latest/setup/migrate/migrate-to-alloy/


# Install Alloy
```sh
git clone https://github.com/felixhummel/provision.git ~/1-provision
cd ~/1-provision/
./alloy
```


# Clone and Configure
```sh
sudo -i

git clone https://github.com/felixhummel/deploy-alloy /opt/alloy
cd /opt/alloy

# set your loki instance data
cat <<EOF > .env
INSTANCE=$HOSTNAME
LOKI_URL=https://loki.prom.0-main.de/loki/api/v1/push
LOKI_BASIC_AUTH_USERNAME=alice
LOKI_BASIC_AUTH_PASSWORD=xxxxxxxxxxxxxxx
EOF

vi .env

# verify config
alloy fmt config.alloy
```


# Test Pushing to Loki
```sh
./bin/loki-ready
./bin/run
```


# Systemd
```sh
# tell systemd to start alloy with our env
mkdir -p /etc/systemd/system/alloy.service.d/
cat <<EOF > /etc/systemd/system/alloy.service.d/override.conf
[Service]
EnvironmentFile=/opt/alloy/.env
Environment=CONFIG_FILE=/opt/alloy/config.alloy
EOF


systemctl daemon-reload
systemctl cat alloy

systemctl enable --now alloy

journalctl -f -u alloy
```
