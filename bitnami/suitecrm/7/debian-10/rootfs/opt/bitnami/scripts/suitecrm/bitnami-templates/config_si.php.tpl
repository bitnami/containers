// This file is based on https://support.sugarcrm.com/Documentation/Sugar_Developer/Sugar_Developer_Guide_9.3/Architecture/Configurator/Silent_Installer_Settings/#config_siphp

<?php

$sugar_config_si = array(
  'setup_site_url' => '{{url_protocol}}://{{SUITECRM_HOST}}',
  'setup_system_name' => 'Bitnami SuiteCRM',
  'setup_db_host_name' => '{{SUITECRM_DATABASE_HOST}}',
  'setup_site_admin_user_name' => '{{SUITECRM_USERNAME}}',
  'setup_site_admin_email' => ' {{SUITECRM_EMAIL}}',
  'setup_site_admin_password' => '{{SUITECRM_PASSWORD}}',
  'demoData' => false,
  'setup_db_type' => 'mysql',
  'setup_db_host_name' => '{{SUITECRM_DATABASE_HOST}}',
  'setup_db_database_name' => '{{SUITECRM_DATABASE_NAME}}',
  'setup_db_port_num' => '{{SUITECRM_DATABASE_PORT_NUMBER}}',
  'setup_db_sugarsales_user' => '{{SUITECRM_DATABASE_USER}}',
  'setup_db_sugarsales_password' => '{{SUITECRM_DATABASE_PASSWORD}}',
  'setup_db_admin_user_name' => '{{SUITECRM_DATABASE_USER}}',
  'setup_db_admin_password' => '{{SUITECRM_DATABASE_PASSWORD}}',
  'setup_db_drop_tables' => false,
  'setup_db_create_database' => true,
  'default_currency_iso4217' => 'USD',
  'default_currency_name' => 'US Dollars',
  'default_currency_significant_digits' => '2',
  'default_currency_symbol' => '$',
  'default_date_format' => 'Y-m-d',
  'default_time_format' => 'H:i',
  'default_decimal_seperator' => '.',
  'default_export_charset' => 'ISO-8859-1',
  'default_language' => 'en_us',
  'default_locale_name_format' => 's f l',
  'default_number_grouping_seperator' => ',',
  'export_delimiter' => ',',
  'verify_client_ip' => {{SUITECRM_VALIDATE_USER_IP}},
  'session_dir' => '/tmp',
);

?>
