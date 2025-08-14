{{/*
Expand the name of the chart.
*/}}
{{- define "my-test-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{/*
Create a default full name using the release name and the chart name.
*/}}
{{- define "my-test-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
