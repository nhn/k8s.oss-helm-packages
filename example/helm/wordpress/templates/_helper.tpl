{{- define "wordpress.fullname"}}
{{- $global := default (dict) .Values.global -}}
{{- $base := default (printf "%s-%s" .Release.Name "wordpress") .Values.wordpress.fullnameOverride -}}
{{- $name := print $base -}}
{{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}

{{- define "mysql.fullname"}}
{{- $global := default (dict) .Values.global -}}
{{- $base := default (printf "%s-%s" .Release.Name "mysql") .Values.fullnameOverride -}}
{{- $name := print $base -}}
{{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}

{{- define "mysql.servicename"}}
{{- $base := default (printf "%s-%s" .Release.Name "mysql.db.svc.cluster.local") .Values.fullnameOverride -}}
{{- $name := print $base -}}
{{- $name | lower | trunc 54 | trimSuffix "-" -}}
{{- end -}}
