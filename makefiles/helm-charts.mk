### HELM CHARTS
# ¯¯¯¯¯¯¯¯

helm.charts.install: ## var: name
	helm upgrade -i ${name} charts/${name} --namespace=default
