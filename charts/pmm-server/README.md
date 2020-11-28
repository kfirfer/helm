### Changing grafana default admin password

```
ln -s /srv/grafana /usr/share/grafana/data; grafana-cli --homepath /usr/share/grafana admin reset-admin-password newpass
```