{{/*
Expand the name of the chart.
*/}}
{{- define "nginx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx.fullname" -}}
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
{{- define "nginx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx.labels" -}}
helm.sh/chart: {{ include "nginx.chart" . }}
{{ include "nginx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nginx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nginx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Calculate the number of workers 
*/}}
{{- define "nginx.workers" -}}
{{- $cpuLimit := 0 -}}
{{- if .Values.resources -}}
{{- if and .Values.resources.limits .Values.resources.limits.cpu -}}
{{- $cpuLimit = include "nginx.parseResourceCpu" .Values.resources.limits -}}
{{- else if and .Values.resources.requests .Values.resources.requests.cpu -}}
{{- $cpuLimit = include "nginx.parseResourceCpu" .Values.resources.requests -}}
{{- end -}}
{{- end -}}
{{- $numOfWorkers := div (sub (add 100000 (mul 100 $cpuLimit)) 1) 100000 -}}
{{ default "auto" $numOfWorkers | toString }}
{{- end -}}


{{- define "nginx.parseResourceCpu" -}}
{{- if hasSuffix "m" .cpu -}}
{{ trimSuffix "m" .cpu | atoi }}
{{- else -}}
{{ mul 1000 (.cpu | atoi) }}
{{- end -}}
{{- end -}}


{{- define "nginx.config.workDir" -}}
{{ default "/tmp" .Values.config.work_dir }}
{{- end -}}

{{- define "nginx.config.workerConnections" -}}
{{ default 1024 .Values.config.worker_connections }}
{{- end -}}
