# mongod.conf
# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/


# where to write logging data.
systemLog:
  destination: file
  quiet: {{MONGODB_DISABLE_SYSTEM_LOG}}
  logAppend: true
  logRotate: reopen
  path: {{MONGODB_LOG_DIR}}/mongodb.log
  verbosity: {{MONGODB_SYSTEM_LOG_VERBOSITY}}

# network interfaces
net:
  port: {{MONGODB_PORT_NUMBER}}
  unixDomainSocket:
    enabled: true
    pathPrefix: {{MONGODB_TMP_DIR}}
  ipv6: {{MONGODB_ENABLE_IPV6}}
  bindIpAll: false
  bindIp: 127.0.0.1

# sharding options
sharding:
  configDB: {{MONGODB_CFG_REPLICA_SET_NAME}}/{{MONGODB_CFG_PRIMARY_HOST}}:{{MONGODB_PORT_NUMBER}}

security:
  keyFile: {{MONGODB_KEY_FILE}}
# process management options
processManagement:
   fork: false
   pidFilePath: {{MONGODB_PID_FILE}}

# set parameter options
setParameter:
   enableLocalhostAuthBypass: false
