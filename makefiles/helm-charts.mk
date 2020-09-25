### HELM CHARTS
# ¯¯¯¯¯¯¯¯

helm.charts.percona-xtradb-cluster.install: ##
	helm upgrade -i percona-xtradb-cluster charts/percona-xtradb-cluster --namespace=default
