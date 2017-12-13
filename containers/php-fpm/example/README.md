# Example Application

## TL;DR

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-node/master/example/kubernetes.yml
```

## Introduction

This example demostrates the use of the `bitnami/php-fpm` image to create a production build of your php application.

For demonstration purposes we will create a phpinfo application, build a image with the tag `bitnami/php-example` and deploy it on a [Kubernetes](https://kubernetes.io) cluster.

## Generate the application

The example application is just the next snippet to show the phpinfo page.

```php
<?phpinfo
  phpinfo();
?>
```

## Build and Test

To build a production Docker image of our application we'll use the `bitnami/php-fpm:6-prod` image, which is a production build of the Bitnami PHP-FPM Image optimized for size.

```dockerfile
FROM bitnami/php-fpm:7.1 as builder
COPY . /app
WORKDIR /app
# Optionally install application dependencies here. For example using composer.

FROM bitnami/php-fpm:7.1-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 9000
CMD ["php-fpm", "-F", "--pid" , "/opt/bitnami/php/tmp/php-fpm.pid", "-c", "/opt/bitnami/php/conf/php-fpm.conf"]
```

The `Dockerfile` consists of two build stages. The first stage uses the development image, `bitnami/php-fpm:7.1`, to copy the application source and install the required application dependencies if required.

The second stage uses the production image, `bitnami/php-fpm:7.1-prod`, and copies over the application source and the dependencies from the previous stage. This creates a minimal Docker image that only consists of the application source and dependencies and the php runtime.

| NOTE: We don't need a multistage build for this specific example as the application does not have dependencies but it is done in this way to demostrate how to use it.

To build the Docker image, execute the command:

```bash
$ docker build -t bitnami/php-example:0.0.1 example/
```

Since the `bitnami/php-fpm:7.1-prod` image is optimized for production deployments it does not include any packages that would bloat the image.

```console
$ docker image ls
REPOSITORY                          TAG                    IMAGE ID            CREATED             SIZE
bitnami/php-example                 0.0.1                  8c72c8c9a73e        32 minutes ago      202MB
```

You can now launch and test the image locally. We will need a web-server like Nginx to server our php app with PHP-FPM. The following docker-compose file deploys both the php application and the nginx server mounting an already configured virtual host.


```yaml
version: '2'
services:
  phpfpm:
    image: 'bitnami/php-example:0.0.1'
  nginx:
    image: 'bitnami/nginx:latest'
    depends_on:
      - phpfpm
    ports:
      - '8080:8080'
      - '8443:8443'
    volumes:
      - ./vhost/myapp.conf:/bitnami/nginx/conf/vhosts/myapp.conf
```
You can start the deployment with this command:

```
$ docker-compose up
```

Finally you can access your application at http://your-ip:8080

## Deployment

The `kubernetes.yml` file from the `example/` folder can be used to deploy our `bitnami/php-example:0.0.1` image to a Kubernetes cluster.

Simply download the Kubernetes manifest and create the Kubernetes resources described in the manifest using the command:

```console
$ kubectl create -f kubernetes.yml
ingress "example-ingress" created
service "example-svc" created
service "nginx-svc" created
persistentvolumeclaim "example-data-pvc" created
deployment "example-deployment" created
deployment "nginx-deployment" created
configmap "nginx-configmap" created
```

From the output of the above command you will notice that we create the following resources:

 - [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
 - [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
 - [Volume](https://kubernetes.io/docs/concepts/storage/volumes/)
    + [ConfigMap](https://kubernetes.io/docs/concepts/storage/volumes/#projected)
    + [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/volumes/#persistentvolumeclaim)
 - [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

> **Note**
>
> Our example application is stateless and does not store any data or does not require any user configurations. As such we do not need to create the `ConfigMap` or `PersistentVolumeClaim` resources. Our `kubernetes.yml` creates these resources strictly to demostrate how they are defined in the manifest.

## Accessing the application

Typically in production you would access the application via a Ingress controller. Our `kubernetes.yml` already defines a `Ingress` resource. Please refer to the [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) documentation to learn how to deploy an ingress controller in your cluster.

> **Hint**
>
> https://kubeapps.com/charts/stable/nginx-ingress

The following are alternate ways of accessing the application, typically used during application development and testing.

Since the service `example-nginx` is defined to be of type `NodePort`, we can set up port forwarding to access our web application like so:

```bash
$ kubectl port-forward $(kubectl get pods -l app=nginx -o jsonpath="{ .items[0].metadata.name }") 8080:8080
```

The command forwards the local port `8080` to port `8080` of the Pod container. You can access the application by visiting the http://localhost:8080.

> **Note:**
>
> If your using minikube, you can access the application by simply executing the following command:
>
> ```bash
> $ minikube service example-svc
> ```

## Health Checks

The `kubernetes.yml` manifest defines default probes to check the health of the application. For our application we are simply probing if the application is responsive to queries on the root resource.

You application can define a route, such as the commonly used `/healthz`, that reports the application status and use that route in the health probes.
