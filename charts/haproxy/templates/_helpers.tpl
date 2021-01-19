{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "haproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "haproxy.fullname" -}}
{{- $name := default "haproxy" .Values.fullnameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "haproxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "haproxy.labels" -}}
app.kubernetes.io/name: {{ include "haproxy.chart" . }}
app: {{ include "haproxy.chart" . }}
helm.sh/chart: {{ include "haproxy.chart" . }}
{{ include "haproxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "haproxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "haproxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "haproxy.name" . }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "haproxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "haproxy.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
