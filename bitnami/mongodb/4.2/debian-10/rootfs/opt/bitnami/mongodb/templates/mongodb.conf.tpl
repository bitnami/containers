# mongod.conf
# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# where and how to store data.
storage:
  dbPath: {{MONGODB_DATA_DIR}}/db
  journal:
    enabled: true
  directoryPerDB: {{MONGODB_ENABLE_DIRECTORY_PER_DB}}

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

# replica set options
#replication:
  #replSetName: {{MONGODB_REPLICA_SET_NAME}}
  #enableMajorityReadConcern: true

# process management options
processManagement:
   fork: false
   pidFilePath: {{MONGODB_PID_FILE}}

# set parameter options
setParameter:
   enableLocalhostAuthBypass: true

# security options
security:
  authorization: disabled
  #keyFile: replace_me
