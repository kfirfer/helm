# ProxySQL Cluster

## General

Set up [ProxySql](http://www.proxysql.com) in a cluster configuration.

See `values.yaml` for configuration details.


# connect to proxysql

```
kubectl exec -it proxysql-proxysql-0 -- mysql -h 127.0.0.1 -u admin -P 6032 -padmin
```
