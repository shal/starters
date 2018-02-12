{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "<CHARTNAME>.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expands image name.
*/}}
{{- define "<CHARTNAME>.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end -}}

{{/*
The standart k8s probe used for redinessProbe and livenessProbe
<CHARTNAME>.probe is http get request
*/}}
{{- define "<CHARTNAME>.probe" -}}
httpGet:
  path: /
  port: {{ .Values.service.internalPort }}
  initialDelay: 5
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "<CHARTNAME>.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Environment for <CHARTNAME> container
*/}}
{{- define "<CHARTNAME>.env" -}}
- name: APP_ENV
  value: {{ .Values.app.env }}
{{- range $key, $value := .Values.app.vars }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/}}
{{- define "<CHARTNAME>.labels.standard" -}}
app: {{ template "<CHARTNAME>.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ template "<CHARTNAME>.chartref" . }}
{{- end -}}

{{/*
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
*/}}
{{- define "<CHARTNAME>.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{/*
Templates in <CHARTNAME>.utils namespace are help functions.
*/}}

{{/*
<CHARTNAME>.utils.tls functions makes host-tls from host name
usage: {{ "www.example.com" | <CHARTNAME>.utils.tls }}
output: www-example-com-tls
*/}}
{{- define "<CHARTNAME>.utils.tls" -}}
{{- $host := index . | replace "." "-" -}}
{{- printf "%s-tls" $host -}}
{{- end -}}
