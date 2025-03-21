{{/*Define vault service account*/}}
{{- define "pulsar.vault.serviceAccount" -}}
{{- if .Values.vault.serviceAccount.created -}}
    {{- if .Values.vault.serviceAccount.name -}}
{{ .Values.vault.serviceAccount.name }}
    {{- else -}}
{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-acct
    {{- end -}}
{{- else -}}
{{ .Values.vault.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Inject vault token values to pod through env variables
*/}}
{{- define "pulsar.vault-secret-key-name" -}}
{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-secret-env-injection
{{- end }}

{{- define "pulsar.console-secret-key-name" -}}
{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-console-admin-passwd
{{- end }}



{{- define "pulsar.vault-unseal-secret-key-name" -}}
{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-unseal-keys
{{- end }}


{{- define "pulsar.vault.url" -}}
http://{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}:8200
{{- end }}


{{- define "pulsar.vault.storage.class" -}}
{{- if and .Values.volumes.local_storage .Values.vault.volume.local_storage }}
storageClassName: "local-storage"
{{- else }}
  {{- if  .Values.vault.volume.storageClassName }}
storageClassName: "{{ .Values.vault.volume.storageClassName }}"
  {{- end -}}
{{- end }}
{{- end }}

{{/*
Define pulsar vault root tokens volume mounts
*/}}
{{- define "pulsar.vault.rootToken.volumeMounts" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-root-token"
  mountPath: "/root/{{ template "pulsar.home" .}}/rootToken"
  subPath: vault-root
{{- end }}

{{/*
Define pulsar vault root tokens volume
*/}}
{{- define "pulsar.vault.rootToken.volumes" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-root-token"
  secret:
    secretName: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-unseal-keys"
{{- end }}




{{/*
Define pulsar create pulsar tokens volume mounts
*/}}
{{- define "pulsar.vault.createPulsarTokens.volumeMounts" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-create-pulsar-tokens"
  mountPath: "/root/{{ template "pulsar.home" .}}/create_pulsar_tokens/"
{{- end }}

{{/*
Define pulsar create pulsar tokens volumes
*/}}
{{- define "pulsar.vault.createPulsarTokens.volumes" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-create-pulsar-tokens"
  configMap:
    name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-create-pulsar-tokens"
{{- end }}


{{/*
Define pulsar init pulsar manager volume mounts
*/}}
{{- define "pulsar.vault.initStreamNativeConsole.volumeMounts" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-init-streamnative-console"
  mountPath: "/root/{{ template "pulsar.home" .}}/init_vault_streamnative_console/"
{{- end }}

{{/*
Define pulsar init pulsar manager volumes
*/}}
{{- define "pulsar.vault.initStreamNativeConsole.volumes" -}}
- name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-init-streamnative-console"
  configMap:
    name: "{{ template "pulsar.fullname" . }}-{{ .Values.vault.component }}-init-streamnative-console"
{{- end }}
