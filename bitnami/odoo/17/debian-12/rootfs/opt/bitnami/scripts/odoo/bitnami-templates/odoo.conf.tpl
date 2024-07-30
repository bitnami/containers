[options]
addons_path = {{ODOO_ADDONS_DIR}}
admin_passwd = {{ODOO_PASSWORD}}
; csv_internal_sep = ,
data_dir = {{ODOO_DATA_DIR}}
db_host = {{ODOO_DATABASE_HOST}}
; db_maxconn = 64
db_name = {{ODOO_DATABASE_NAME}}
db_password = {{ODOO_DATABASE_PASSWORD}}
db_port = {{ODOO_DATABASE_PORT_NUMBER}}
; db_sslmode = prefer
; https://www.postgresql.org/docs/current/manage-ag-templatedbs.html
db_template = template1
db_user = {{ODOO_DATABASE_USER}}
dbfilter = {{ODOO_DATABASE_FILTER}}
debug_mode = {{odoo_debug}}
email_from = {{ODOO_EMAIL}}
http_port = {{ODOO_PORT_NUMBER}}
; limit_memory_hard = 2684354560
; limit_memory_soft = 2147483648
; limit_request = 8192
; https://www.odoo.com/forum/help-1/question/cpu-time-limit-exceeded-how-to-solve-it-87922
limit_time_cpu = 90
limit_time_real = 150
list_db = {{list_db}}
; log_db = False
; log_handler = [':INFO']
; log_level = info
; logfile = {{ODOO_LOG_FILE}}
{{event_port_parameter}} = {{ODOO_LONGPOLLING_PORT_NUMBER}}
; https://www.odoo.com/es_ES/forum/ayuda-1/could-not-obtain-lock-on-row-in-relation-ir-cron-74519
max_cron_threads = 1
pidfile = {{ODOO_PID_FILE}}
; Odoo will always be running behind a proxy (e.g. Docker or Apache)
proxy_mode = True
; osv_memory_age_limit = 1.0
; osv_memory_count_limit = False
; pg_path =
; smtp_password = False
; smtp_port = 25
; smtp_server = localhost
; smtp_ssl = False
; smtp_user = False
; without_demo = False
; workers = 2
