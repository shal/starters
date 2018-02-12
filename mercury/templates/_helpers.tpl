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
{{- $delay := 5 -}}
httpGet:
  path: /
  port: {{ .Values.service.internalPort }}
  initialDelay: {{ $delay }}
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
Environment varibles for <CHARTNAME> container
*/}}
{{- define "<CHARTNAME>.envs" -}}
{{- range $key, $value := .Values.<CHARTNAME>.vars }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
Expands configuration file name for <CHARTNAME>
*/}}
{{- define "<CHARTNAME>.config.name" -}}
{{- $name := include "<CHARTNAME>.fullname" . -}}
{{- printf "%s-config" $name -}}
{{- end -}}

{{/*
Expands persistant volume claim for <CHARTNAME>
*/}}
{{- define "<CHARTNAME>.pvc.name" -}}
{{- $name := include "<CHARTNAME>.fullname" . -}}
{{- printf "%s-pvc" $name -}}
{{- end -}}

{{/*
Override default <CHARTNAME> container command
*/}}
{{- define "<CHARTNAME>.command" -}}
{{- $cmd := default "<CHARTNAME>" .Values.<CHARTNAME>.command -}}
{{- if kindIs "string" $cmd -}}
{{ template "<CHARTNAME>.utils.to_array" $cmd }}
{{- else if kindIs "slice" $cmd -}}
{{- $cmd | toJson -}}
{{- end -}}
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
*/}}
{{- define "<CHARTNAME>.utils.to_array" -}}

{{- if kindIs "string" . -}}
{{- . | splitList " " | toJson -}}
{{- else -}}
{{- fail "Error. Invalid type" -}}
{{- end -}}
{{- end -}}
