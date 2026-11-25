{{/*
Variables de entorno compartidas entre el main y el worker de n8n.
*/}}
{{- define "n8n.env" -}}
- name: GENERIC_TIMEZONE
  value: {{ .Values.timezone | quote }}
- name: TZ
  value: {{ .Values.timezone | quote }}
- name: DB_TYPE
  value: postgresdb
- name: DB_POSTGRESDB_HOST
  value: {{ .Values.database.host | quote }}
- name: DB_POSTGRESDB_PORT
  value: {{ .Values.database.port | quote }}
- name: DB_POSTGRESDB_DATABASE
  value: {{ .Values.database.name | quote }}
- name: DB_POSTGRESDB_USER
  value: {{ .Values.database.user | quote }}
- name: DB_POSTGRESDB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: DB_POSTGRESDB_PASSWORD
- name: EXECUTIONS_MODE
  value: queue
- name: QUEUE_BULL_REDIS_HOST
  value: {{ .Values.redis.host | quote }}
- name: QUEUE_BULL_REDIS_PORT
  value: {{ .Values.redis.port | quote }}
- name: QUEUE_BULL_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: QUEUE_BULL_REDIS_PASSWORD
- name: QUEUE_BULL_REDIS_TLS
  value: {{ .Values.redis.tls | quote }}
- name: N8N_ENCRYPTION_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: N8N_ENCRYPTION_KEY
- name: N8N_PORT
  value: {{ .Values.service.port | quote }}
- name: N8N_PROTOCOL
  value: http
- name: N8N_HOST
  value: {{ .Values.publicHost | quote }}
- name: WEBHOOK_URL
  value: {{ .Values.publicUrl | quote }}
- name: N8N_EDITOR_BASE_URL
  value: {{ .Values.publicUrl | quote }}
- name: N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS
  value: "true"
{{- end }}

{{- define "n8n.initContainer" -}}
- name: init-efs-perms
  image: busybox:1.36
  command: ["sh", "-c", "mkdir -p /data && chown -R 1000:1000 /data && chmod -R 755 /data"]
  securityContext:
    runAsUser: 0
  volumeMounts:
    - name: n8n-data
      mountPath: /data
{{- end }}
