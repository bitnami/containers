# Example Application

## TL;DR

```bash
$ kubectl create -f https://raw.githubusercontent.com/bitnami/bitnami-docker-python/master/example/kubernetes.yml
```

## Introduction

This example demostrates the use of the `bitnami/python` image to create a production build of your python application.

For demonstration purposes we'll bootstrap a [Django](https://www.djangoproject.com/) application, build a image with the tag `bitnami/python-example` and deploy it on a [Kubernetes](https://kubernetes.io) cluster.

## Generate the application

The example application is a [Django](https://www.djangoproject.com/) application bootstrapped using the `django-admin` utility.

```bash
$ django-admin startproject example
```

## Build and Test

To build a production Docker image of our application we'll use the `bitnami/python:2-prod` image, which is a production build of the Bitnami Python Image optimized for size.

```dockerfile
FROM bitnami/python:2 as builder
COPY . /app
WORKDIR /app
RUN virtualenv . && \
    . bin/activate && \
    pip install django && \
    python manage.py migrate

FROM bitnami/python:2-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 8000
CMD bash -c "source bin/activate && python manage.py runserver 0:8000"
```

The `Dockerfile` consists of two build stages. The first stage uses the development image, `bitnami/python:2`, to copy the application source, create a virtualenv and install the required application modules with `pip`.

The second stage uses the production image, `bitnami/python:2-prod`, and copies over the application source and the installed modules from the previous stage. This creates a minimal Docker image that only consists of the application source, python modules and the python runtime.

To build the Docker image, execute the command:

```bash
$ docker build -t bitnami/python-example:0.0.1 example/
```

Since the `bitnami/python:2-prod` image is optimized for production deployments it does not include any packages that would bloat the image.

```console
$ docker image ls
REPOSITORY                          TAG                    IMAGE ID            CREATED             SIZE
bitnami/python-example              0.0.1                  0d43bbca1cd2        22 seconds ago      193MB
```

You can now launch and test the image locally.

```console
$ docker run -it --rm -p 8000:8000 bitnami/python-example:0.0.1

Performing system checks...

System check identified no issues (0 silenced).
November 09, 2017 - 11:25:27
Django version 1.11.7, using settings 'example.settings'
Starting development server at http://0:8000/
Quit the server with CONTROL-C.
```

Finally, push the image to the Docker registry

```bash
$ docker push bitnami/python-example:0.0.1
```

## Deployment

The `kubernetes.yml` file from the `example/` folder can be used to deploy our `bitnami/python-example:0.0.1` image to a Kubernetes cluster.

Simply download the Kubernetes manifest and create the Kubernetes resources described in the manifest using the command:

```console
$ kubectl create -f kubernetes.yml
ingress "example-ingress" created
service "example-svc" created
persistentvolumeclaim "example-data-pvc" created
deployment "example-deployment" created
```

From the output of the above command you will notice that we create the following resources:

 - [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
 - [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
 - [Volume](https://kubernetes.io/docs/concepts/storage/volumes/)
    + [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/volumes/#persistentvolumeclaim)
 - [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

> **Note**
>
> Our example application is stateless and does not store any data or does not require any user configurations. As such we do not need to create the `PersistentVolumeClaim` resource. Our `kubernetes.yml` creates this resource strictly to demostrate how it is defined in the manifest.

## Accessing the application

Typically in production you would access the application via a Ingress controller. Our `kubernetes.yml` already defines a `Ingress` resource. Please refer to the [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) documentation to learn how to deploy an ingress controller in your cluster.

> **Hint**
>
> https://kubeapps.com/charts/stable/nginx-ingress

The following are alternate ways of accessing the application, typically used during application development and testing.

Since the service `example-svc` is defined to be of type `NodePort`, we can set up port forwarding to access our web application like so:

```bash
$ kubectl port-forward $(kubectl get pods -l app=example -o jsonpath="{ .items[0].metadata.name }") 8000:8000
```

The command forwards the local port `8000` to port `8000` of the Pod container. You can access the application by visiting the `http://localhost:8000`.

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
