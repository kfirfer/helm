### HELM CHARTS
# ¯¯¯¯¯¯¯¯

helm.charts.install: ## var: chart,releasename
	helm upgrade -i ${releasename} charts/${chart} --namespace=default
