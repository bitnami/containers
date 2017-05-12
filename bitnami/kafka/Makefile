build:
	docker build -t bitnami/kafka . 

run:
	docker run -it -e KAFKA_ADVERTISED_HOST_NAME="kafka.kubeless" \
	-e KAFKA_ADVERTISED_PORT="9092" \
	-e KAFKA_PORT="9092" \
	-e KAFKA_ZOOKEEPER_CONNECT="zookeeper.kubeless:2181" \
	-e KAFKA_ADVERTISED_HOST_NAME="kafka.kubeless" \
	-e KAFKA_DELETE_TOPIC_ENABLE="true" \
	-e KAFKA_AUTO_CREATE_TOPICS_ENABLE="true" \
	-p 9092:9092  bitnami/kafka 
	auto.create.topics.enable=true

shell:
	docker run -it -e KAFKA_ADVERTISED_HOST_NAME="kafka.kubeless" \
	-e KAFKA_ADVERTISED_PORT="9092" \
	-e KAFKA_PORT="9092" \
	-e KAFKA_ADVERTISED_HOST_NAME="kafka.kubeless" \
	-e KAFKA_ZOOKEEPER_CONNECT="zookeeper.kubeless:2181" \
	-e KAFKA_DELETE_TOPIC_ENABLE="true" \
	-e KAFKA_AUTO_CREATE_TOPICS_ENABLE="true" \
	-p 9092:9092  bitnami/kafka  bash 

publish: 
	docker push bitnami/kafka

