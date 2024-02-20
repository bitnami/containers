{{!-- https://github.com/tensorflow/serving/blob/021efbd/tensorflow_serving/servables/tensorflow/testdata/monitoring_config.txt --}}
prometheus_config: {
  enable: {{tensorflow_monitoring_enable}},
  path: "{{TENSORFLOW_SERVING_MONITORING_PATH}}"
}
