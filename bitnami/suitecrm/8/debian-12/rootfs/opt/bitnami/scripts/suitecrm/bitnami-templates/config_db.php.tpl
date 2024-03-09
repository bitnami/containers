// This file is based on a config.php file from a completed install. You can obtain it by disabling the wizard and browsing to the application.
// This will be used for new installs using existing databases, where we will first use a very basic config file and then repair via the app to add missing fields.
<?php
$sugar_config = array (
  'dbconfig' =>
  array (
    'db_host_name' => '{{db_host}}',
    'db_host_instance' => '',
    'db_user_name' => '{{db_user}}',
    'db_password' => '{{db_pass}}',
    'db_name' => '{{db_name}}',
    'db_type' => 'mysql',
    'db_port' => '{{db_port}}',
    'db_manager' => 'MysqliManager',
  ),
  'dbconfigoption' =>
  array (
    'persistent' => true,
    'autofree' => false,
    'debug' => 0,
    'ssl' => false,
  ),
);
