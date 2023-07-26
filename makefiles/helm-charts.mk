### HELM CHARTS
# ¯¯¯¯¯¯¯¯

helm.charts.install: ## var: chart,releasename
	helm upgrade -i ${releasename} charts/${chart} --namespace=default


helm.template.test:
	helm template mysqldump charts/mysqldump --values charts/mysqldump/values-test.yaml --debug

