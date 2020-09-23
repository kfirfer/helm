# Documentation
https://www.percona.com/doc/percona-xtradb-cluster/8.0/index.html


# Crash recovery
https://www.percona.com/doc/percona-xtradb-cluster/8.0/howtos/crash-recovery.html



# Benchmark
https://www.percona.com/blog/2020/02/07/how-to-measure-mysql-performance-in-kubernetes-with-sysbench/


#### Create sysbench pods
```
kubectl run -it --rm sysbench-client-1 --image=perconalab/sysbench:latest --restart=Never --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "nuc01" } } }' -- bash

kubectl run -it --rm sysbench-client-2 --image=perconalab/sysbench:latest --restart=Never --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "nuc02" } } }' -- bash

kubectl run -it --rm sysbench-client-3 --image=perconalab/sysbench:latest --restart=Never --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "nuc03" } } }' -- bash
```

#### Prepare data:
```
sysbench oltp_read_only --tables=10 --table_size=100000  --mysql-host=percona-xtradb-cluster-pxc-1.percona-xtradb-cluster-pxc.zigi-dev.svc.cluster.local --mysql-port=3306 --mysql-user=root --mysql-password=KALc35rWlF --mysql-db=sbtest prepare
```


#### Running benchmark


Read-only
```
sysbench oltp_read_only --tables=10 --table_size=100000 --mysql-host=percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc.zigi-dev.svc.cluster.local --mysql-port=3306 --mysql-user=root --mysql-password=KALc35rWlF --mysql-db=sbtest --time=10 --threads=16 --report-interval=1 run
```

Read-write
```
sysbench oltp_read_write --tables=10 --table_size=100000 --mysql-host=percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc.zigi-dev.svc.cluster.local --mysql-port=3306 --mysql-user=root --mysql-password=KALc35rWlF --mysql-db=sbtest --time=10 --threads=16 --report-interval=1 run
```


# Misc

mysqld  --user=mysql 


mysql bootstrap-pxc


/bin/bash /entrypoint.sh mysqld


First node:

rm -rf /var/lib/mysql/*

First node:
```
mysqld --initialize-insecure \
    --datadir=/var/lib/mysql \
    --user=mysql

mysqld --datadir=/var/lib/mysql \
    --user=mysql --wsrep_cluster_name=pxc \
    --wsrep_node_name=percona-xtradb-cluster-pxc-0 \
    --wsrep_cluster_address=gcomm:// \
    --wsrep_cluster_name=pxc \
    --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_node_address="percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc" \
    --pxc_strict_mode="PERMISSIVE" \
    --wsrep-new-cluster
```

Second node:
```
mysqld --datadir=/var/lib/mysql \
    --user=mysql --wsrep_cluster_name=pxc \
    --wsrep_node_name=percona-xtradb-cluster-pxc-1 \
    --wsrep_cluster_address=gcomm://percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc,percona-xtradb-cluster-pxc-1.percona-xtradb-cluster-pxc \
    --wsrep_cluster_name=pxc \
    --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_node_address="percona-xtradb-cluster-pxc-1.percona-xtradb-cluster-pxc" \
    --pxc_strict_mode="PERMISSIVE"
```


Third node:

```
mysqld --datadir=/var/lib/mysql \
    --user=mysql --wsrep_cluster_name=pxc \
    --wsrep_node_name=percona-xtradb-cluster-pxc-2 \
    --wsrep_cluster_address=gcomm://percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc,percona-xtradb-cluster-pxc-1.percona-xtradb-cluster-pxc,percona-xtradb-cluster-pxc-2.percona-xtradb-cluster-pxc \
    --wsrep_cluster_name=pxc \
    --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_node_address="percona-xtradb-cluster-pxc-2.percona-xtradb-cluster-pxc" \
    --pxc_strict_mode="PERMISSIVE"
```



        GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
        CREATE USER 'xtrabackup'@'%' IDENTIFIED BY '$XTRABACKUP_PASSWORD';
        GRANT RELOAD,PROCESS,LOCK TABLES,REPLICATION CLIENT ON *.* TO 'xtrabackup'@'%';
        GRANT REPLICATION CLIENT ON *.* TO monitor@'%' IDENTIFIED BY 'monitor';
        GRANT PROCESS ON *.* TO monitor@localhost IDENTIFIED BY 'monitor';
        CREATE USER 'mysql'@'localhost' IDENTIFIED BY '' ;
        DROP DATABASE IF EXISTS test ;
        FLUSH PRIVILEGES ;

mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY 'a123123';"
mysql -uroot -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -e "FLUSH PRIVILEGES ;"
mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY 'a123123';"

show status like 'wsrep%';


First node:
/bin/bash /entrypoint.sh mysqld


Rest of the nodes:
export CLUSTER_JOIN=percona-xtradb-cluster-pxc-0.percona-xtradb-cluster-pxc
/bin/bash /entrypoint.sh mysqld



