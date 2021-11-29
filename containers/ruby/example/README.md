# Example Application

## TL;DR

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-ruby/master/example/kubernetes.yml
```

## Introduction

This example demostrates the use of the `bitnami/ruby` image to create a production build of your ruby application.

For demonstration purposes we'll bootstrap a [Rails](http://rubyonrails.org/) application, build a image with the tag `bitnami/ruby-example` and deploy it on a [Kubernetes](https://kubernetes.io) cluster.

## Generate the application

The example application is a [Rails](http://rubyonrails.org/) application bootstrapped using the `rails new` command.

```bash
$ rails new example --skip-active-record --skip-bundle
```

## Build and Test

To build a production Docker image of our application we'll use the `bitnami/ruby:2.4-prod` image, which is a production build of the Bitnami Ruby Image optimized for size.

```dockerfile
FROM bitnami/ruby:2.4 as builder
ENV RAILS_ENV="production"
COPY . /app
WORKDIR /app
RUN bundle install --no-deployment
RUN bundle install --deployment
RUN bin/rails generate controller Welcome index
RUN bin/bundle exec rake assets:precompile


FROM bitnami/ruby:2.4-prod
ENV RAILS_ENV="production" \
    SECRET_KEY_BASE="your_production_key" \
    RAILS_SERVE_STATIC_FILES="yes"
RUN install_packages libssl1.0.0
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 3000
CMD ["bin/rails", "server"]
```

The `Dockerfile` consists of two build stages. The first stage uses the development image, `bitnami/ruby:2.4`, to copy the application source, install the required gems using `bundle install`, generate a dummy controller and precompile the assets. The `RAILS_ENV` environment variable is defined so that `bundle install` only installs the application gems that are required in `production` executions and also for the rails server to start in production mode.

The second stage uses the production image, `bitnami/ruby:2.4-prod`, and copies over the application source and the installed gems from the previous stage. This creates a minimal Docker image that only consists of the application source, gems and the ruby runtime.

To build the Docker image, execute the command:

```bash
$ docker build -t bitnami/ruby-example:0.0.1 example/
```

Since the `bitnami/ruby:2.4-prod` image is optimized for production deployments it does not include any packages that would bloat the image.

```console
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
bitnami/ruby-example     0.0.1               847d58b5bc8a        4 minutes ago       203MB
```

You can now launch and test the image locally. You will need to access to `http://YOUR_IP:3000/welcome/index`

```console
$ docker run -it --rm -p 3000:3000 bitnami/ruby-example:0.0.1

=> Booting Puma
=> Rails 5.1.4 application starting in production
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.10.0 (ruby 2.4.2-p198), codename: Russell's Teapot
* Min threads: 5, max threads: 5
* Environment: production
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

Finally, push the image to the Docker registry

```bash
$ docker push bitnami/ruby-example:0.0.1
```

## Deployment

The `kubernetes.yml` file from the `example/` folder can be used to deploy our `bitnami/ruby-example:0.0.1` image to a Kubernetes cluster.

Simply download the Kubernetes manifest and create the Kubernetes resources described in the manifest using the command:

```console
$ kubectl create -f kubernetes.yml
ingress "example-ingress" created
service "example-svc" created
configmap "example-configmap" created
persistentvolumeclaim "example-data-pvc" created
deployment "example-deployment" created
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

Since the service `example-svc` is defined to be of type `NodePort`, we can set up port forwarding to access our web application like so:

```bash
$ kubectl port-forward $(kubectl get pods -l app=example -o jsonpath="{ .items[0].metadata.name }") 3000:3000
```

The command forwards the local port `3000` to port `3000` of the Pod container. You can access the application by visiting the `http://localhost:3000/welcome/index`.

> **Note:**
>
> If you are using minikube, you can access the application by simply executing the following command:
>
> ```bash
> $ minikube service example-svc
> ```

## Health Checks

The `kubernetes.yml` manifest defines default probes to check the health of the application. For our application we are simply probing if the application is responsive to queries on the root resource.

You application can define a route, such as the commonly used `/healthz`, that reports the application status and use that route in the health probes.
