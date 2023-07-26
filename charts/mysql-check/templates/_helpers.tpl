{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mysql-check.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if semverCompare "< 1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v2alpha1" }}
{{- else if semverCompare ">=1.22-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1" }}
{{- else if semverCompare ">=1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1beta1" }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mysql-check.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mysql-check.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mysql-check.labels" -}}
helm.sh/chart: {{ include "mysql-check.chart" . }}
{{ include "mysql-check.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mysql-check.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mysql-check.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mysql-check.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mysql-check.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
