<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!-- START SNIPPET: example -->
<beans
  xmlns="http://www.springframework.org/schema/beans"
  xmlns:amq="http://activemq.apache.org/schema/core"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
  http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core.xsd">

    <!-- Allows us to use system properties as variables in this configuration file -->
    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="locations">
            <value>file:${activemq.conf}/credentials.properties</value>
        </property>
    </bean>

    <!--
        The <broker> element is used to configure the ActiveMQ Classic broker.
    -->
    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}">

        <!--
            For better performances use VM cursor and small memory limit.
            For more information, see:

            http://activemq.apache.org/message-cursors.html

            Also, if your producer is "hanging", it's probably due to producer flow control.
            For more information, see:
            http://activemq.apache.org/producer-flow-control.html
        -->

        <destinationPolicy>
            <policyMap>
              <policyEntries>
                <policyEntry topic=">" producerFlowControl="true">
                    <!-- The constantPendingMessageLimitStrategy is used to prevent
                         slow topic consumers to block producers and affect other consumers
                         by limiting the number of messages that are retained
                         For more information, see:

                         http://activemq.apache.org/slow-consumer-handling.html

                    -->
                  <pendingMessageLimitStrategy>
                    <constantPendingMessageLimitStrategy limit="1000"/>
                  </pendingMessageLimitStrategy>
                </policyEntry>
                <policyEntry queue=">" producerFlowControl="true" memoryLimit="1mb">
                  <!-- Use VM cursor for better latency
                       For more information, see:

                       http://activemq.apache.org/message-cursors.html

                  <pendingQueuePolicy>
                    <vmQueueCursor/>
                  </pendingQueuePolicy>
                  -->
                </policyEntry>
              </policyEntries>
            </policyMap>
        </destinationPolicy>


        <!--
            The managementContext is used to configure how ActiveMQ Classic is exposed in
            JMX. By default, ActiveMQ Classic uses the MBean server that is started by
            the JVM. For more information, see:

            http://activemq.apache.org/jmx.html
        -->
        <managementContext>
            <managementContext createConnector="false"/>
        </managementContext>

        <!--
            Configure message persistence for the broker. The default persistence
            mechanism is the KahaDB store (identified by the kahaDB tag).
            For more information, see:

            http://activemq.apache.org/persistence.html
        -->
        <persistenceAdapter>
            <kahaDB directory="${activemq.data}/kahadb"/>
        </persistenceAdapter>


          <!--
            The systemUsage controls the maximum amount of space the broker will
            use before slowing down producers. For more information, see:
            http://activemq.apache.org/producer-flow-control.html
            If using ActiveMQ Classic embedded - the following limits could safely be used:

        <systemUsage>
            <systemUsage>
                <memoryUsage>
                    <memoryUsage limit="20 mb"/>
                </memoryUsage>
                <storeUsage>
                    <storeUsage limit="1 gb"/>
                </storeUsage>
                <tempUsage>
                    <tempUsage limit="100 mb"/>
                </tempUsage>
            </systemUsage>
        </systemUsage>
        -->
          <systemUsage>
            <systemUsage>
                <memoryUsage>
                    <memoryUsage limit="64 mb"/>
                </memoryUsage>
                <storeUsage>
                    <storeUsage limit="10 gb"/>
                </storeUsage>
                <tempUsage>
                    <tempUsage limit="5 gb"/>
                </tempUsage>
            </systemUsage>
        </systemUsage>

        <!--
            The transport connectors expose ActiveMQ Classic over a given protocol to
            clients and other brokers. For more information, see:

            http://activemq.apache.org/configuring-transports.html
        -->
    <transportConnectors>
      <!--  DOS protection, limit concurrent connections to 1000 and frame size to 100MB  -->
      <transportConnector name="openwire" uri="tcp://127.0.0.1:{{ACTIVEMQ_OPENWIRE_PORT_NUMBER}}?aximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
      <transportConnector name="amqp" uri="amqp://127.0.0.1:{{ACTIVEMQ_AQMQ_PORT_NUMBER}}?aximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
      <transportConnector name="stomp" uri="stomp://127.0.0.1:{{ACTIVEMQ_STOMP_PORT_NUMBER}}?aximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
      <transportConnector name="mqtt" uri="mqtt://127.0.0.1:{{ACTIVEMQ_MQTT_PORT_NUMBER}}?aximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
      <transportConnector name="ws" uri="ws://127.0.0.1:{{ACTIVEMQ_WEBSOCKET_PORT_NUMBER}}?aximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
    </transportConnectors>
    <!--  destroy the spring context on shutdown to stop jetty  -->
    <shutdownHooks>
      <bean xmlns="http://www.springframework.org/schema/beans" class="org.apache.activemq.hooks.SpringContextHook" />
    </shutdownHooks>
  </broker>
  <!--
        Enable web consoles, REST and Ajax APIs and demos

        Take a look at ${ACTIVEMQ_HOME}/conf/jetty.xml for more details
     -->
  <import resource="jetty.xml" />
</beans>
<!-- END SNIPPET: example -->