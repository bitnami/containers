Bitnami Nginx image

## Usage

### Basic usage

You can run the Nginx process executing:
```
docker run -it bitnami/nginx
```

If you want to run in the background use: 

```
docker run -itd bitnami/nginx
```

### Accessing Nginx from the host

By default the container exposes the port 80 and 443, ports that can be mapped doing

```
docker run -it -p 8080:80 -p 8081:443 bitnami/nginx
```

Then Nginx should be accessible via [HTTP](http://localhost:8080) or [HTTPS](http://localhost:8081)

### Volumes

By default the container will expose 3 volumes: /logs, /conf and /app. 

#### Logs volume

By default the Nginx container will show the logs via stdout (accessible via docker logs), but if you mount the volume in your host, the Nginx access and error logs will be placed there instead. 

```
docker run -it -v /my-logs:/logs bitnami/nginx 
```
#### Conf volume

If you already have some nginx configuration files that want to use inside the container or just want to modify the default ones from your host machine, just mount the /conf volume.   

```
docker run -it -v /my-conf:/conf bitnami/nginx 
```

#### App volume

/app is the directory inside the container which Nginx uses as workdir for static files. If you want to add your own app, just mount this volume and modify any vhost configuration using the config volume explained in the previour paragraph.

```
docker run -it -v /my-app:/app bitnami/nginx 
```
An example mouting all the volumes and exposing the ports looks like:
```
docker run -it -p 8080:80 -p 8081:443 \
  -v /my-conf:/conf \
  -v /my-app:/app
  -v /my-logs:/logs \
  bitnami/nginx

```

### Linking to another containers.

TODO

