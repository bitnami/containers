#!/bin/bash

export JAVA_HOME="{{JAVA_HOME}}"
export JAVA_OPTS="{{JAVA_OPTS}}"
export CATALINA_PID="{{TOMCAT_PID_FILE}}"

# Load Tomcat Native library
export LD_LIBRARY_PATH="{{TOMCAT_LIB_DIR}}:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
