{{!
  This file is used when PHPBB_SKIP_BOOTSTRAP=yes as there is no way to automatically generate it
  source: https://www.phpbb.com/support/docs/en/3.3/kb/article/rebuilding-your-configphp-file/
}}
<?php
$dbms = 'phpbb\\db\\driver\\mysqli';
$dbhost = '{{PHPBB_DATABASE_HOST}}';
$dbport = '{{PHPBB_DATABASE_PORT_NUMBER}}';
$dbname = '{{PHPBB_DATABASE_NAME}}';
$dbuser = '{{PHPBB_DATABASE_USER}}';
$dbpasswd = '{{PHPBB_DATABASE_PASSWORD}}';
$table_prefix = 'phpbb_';
$phpbb_adm_relative_path = 'adm/';
$acm_type = 'phpbb\\cache\\driver\\file';

@define('PHPBB_INSTALLED', true);
// @define('PHPBB_DISPLAY_LOAD_TIME', true);
@define('PHPBB_ENVIRONMENT', 'production');
// @define('DEBUG_CONTAINER', true);
