#!/bin/bash

# Where is the `kubeless` binary?
#yes | ~/go/bin/kubeless install 

# Expose the services as NodePort
#for i in kafka zookeeper ; do 
    # Change to NodePort
    # kubectl patch  svc $i --namespace=kubeless --type json -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort" }]'
#done 


snipet="kubectl run  -i --rm client$RANDOM --quiet=true  --image=bitnami/kafka:0.10.2.1   --restart=Never --"

echo "Creating bitnami topic"
echo "======================"
$snipet /opt/bitnami/kafka/bin/kafka-topics.sh --create  --zookeeper zookeeper.kubeless:2181  --topic bitnami --replication-factor 1  --partitions 1 --if-not-exists
echo "===== DONE =========="

echo "Listing topics"
echo "======================"
$snipet  /opt/bitnami/kafka/bin/kafka-topics.sh --list  --zookeeper zookeeper.kubeless:2181
echo "===== DONE =========="

echo "Describing topic bitnami"
echo "======================"
$snipet  /opt/bitnami/kafka/bin/kafka-topics.sh --describe --zookeeper zookeeper.kubeless:2181 --topic bitnami
echo "===== DONE =========="

echo "Producing events"
echo "======================"
$snipet /opt/bitnami/kafka/bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic bitnami --num-records 500 --record-size 5 --throughput -1 --producer-props acks=1 bootstrap.servers=kafka.kubeless:9092 buffer.memory=104857600 batch.size=10   
echo "===== DONE =========="

 
echo "Consuming Events"
echo "======================"
$snipet /opt/bitnami/kafka/bin/kafka-consumer-perf-test.sh  --zookeeper zookeeper.kubeless:2181 --topic bitnami --messages 500  --threads 1 
echo "===== DONE =========="

