# What is PHP-FPM?

> PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some
> additional features useful for sites of any size, especially busier sites.

[php-fpm.org](http://php-fpm.org/)

# TLDR

```bash
docker run -it --name phpfpm bitnami/php-fpm
```

## Docker Compose

```
phpfpm:
  image: bitnami/php-fpm
  volumes:
    - path/to/php/app:/app
```

# Get this image

The recommended way to get the Bitnami PHP-FPM Docker Image is to pull the prebuilt image from the
[Docker Hub Registry](https://hub.docker.com).

```bash
docker pull bitnami/php-fpm:5.5.26-2-r01
```

To always get the latest version, pull the `latest` tag.

```bash
docker pull bitnami/php-fpm:latest
```

If you wish, you can also build the image yourself.

```bash
git clone https://github.com/bitnami/bitnami-docker-php-fpm.git
cd docker-php-fpm
docker build -t bitnami/php-fpm
```

# Linking

This image is designed to be used with a web server to serve your PHP app, you can use the linking
system provided by Docker to do this.

## Serving your PHP app through an nginx frontend

We will use PHP-FPM with nginx to serve our PHP app. Doing so will allow us to setup more complex
configuration, serve static assets using nginx, load balance to different PHP-FPM instances, etc.

### Step 1: Create a virtual host

Let's create an nginx virtual host to reverse proxy to our PHP-FPM container.
[The Bitnami nginx Docker Image](https://github.com/bitnami/bitnami-docker-nginx) ships with some
example virtual hosts for connecting to Bitnami runtime images. We will make use of the PHP-FPM
example:

```
server {
    listen 0.0.0.0:80;
    server_name yourapp.com;

    access_log /logs/yourapp_access.log;
    error_log /logs/yourapp_error.log;

    root /app;

    location / {
        index index.php;
    }

    location ~ \.php$ {
        # fastcgi_pass [PHP_FPM_LINK_NAME]:9000;
        fastcgi_pass yourapp:9000;
        fastcgi_index index.php;
        include fastcgi.conf;
    }
}

```

Notice we've substituted the link alias name `yourapp`, we will use the same name when creating the
link.

Copy the virtual host above, saving the file somewhere on your host. We will mount it as a volume
in our nginx container.

### Step 2: Run the PHP-FPM image with a specific name

Docker's linking system uses container ids or names to reference containers. We can explicitly
specify a name for our PHP-FPM server to make it easier to connect to other containers.

```
docker run -it --name phpfpm -v /path/to/php/app:/app bitnami/php-fpm
```

or using Docker Compose:

```
phpfpm:
  image: bitnami/php-fpm
  volumes:
    - path/to/php/app:/app
```

### Step 3: Run the nginx image and link it to the PHP-FPM server

Now that we have our PHP-FPM server running, we can create another container that links to it by
giving Docker the `--link` option. This option takes the id or name of the container we want to link
it to as well as a hostname to use inside the container, separated by a colon. For example, to have
our PHP-FPM server accessible in another container with `yourapp` as it's hostname we would pass
`--link phpfpm:yourapp` to the Docker run command.

```bash
docker run -it -v /path/to/vhost.conf:/bitnami/nginx/conf/vhosts/yourapp.conf \
  --link phpfpm:yourapp \
  bitnami/nginx
```

or using Docker Compose:

```
nginx:
  image: bitnami/nginx
  links:
    - phpfpm:yourapp
  volumes:
    - path/to/vhost.conf:/bintami/nginx/conf/yourapp.conf
```

We started the nginx server, mounting the virtual host we created in
[Step 1](#step-1-create-a-virtual-host), and created a link to the PHP-FPM server with the alias
`yourapp`.

# PHP runtime

Since this image bundles a PHP runtime, you may want to make use of PHP outside of PHP-FPM. By
default, running this image will start a server. To use the PHP runtime instead, we can override the
the default command Docker runs by stating a different command to run after the image name.

## Entering the REPL

PHP provides a REPL where you can interactively test and try things out in PHP.

```bash
docker run -it --name phpfpm bitnami/php-fpm php -a
```

**Further Reading:**

- [PHP Interactive Shell Documentation](http://php.net/manual/en/features.commandline.interactive.php)

# Running your PHP script

The default work directory for the PHP-FPM image is `/app`. You can mount a folder from your host
here that includes your PHP script, and run it normally using the `php` command.

```bash
docker run -it --name php-fpm -v /path/to/php/app:/app bitnami/php-fpm \
  php-fpm script.php
```

# Configuration

This container looks for configuration in `/bitnami/phpfpm/conf`. You can mount a directory there
with your own configuration, or the default configuration will be copied to your directory if it is
empty.

### Step 1: Run the PHP-FPM image

Run the PHP-FPM image, mounting a directory from your host.

```bash
docker run --name phpfpm -v /path/to/phpfpm/conf:/bitnami/phpfpm/conf bitnami/php-fpm
```

or using Docker Compose:

```
phpfpm:
  image: bitnami/php-fpm
  volumes:
    - path/to/phpfpm/conf:/bitnami/phpfpm/conf
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/phpfpm/conf/php-fpm.conf
```

### Step 4: Restart PHP-FPM

After changing the configuration, restart your PHP-FPM container for changes to take effect.

```bash
docker restart phpfpm
```

or using Docker Compose:

```bash
docker-compose restart phpfpm
```

# Logging

The Bitnami PHP-FPM Docker Image supports two different logging modes: logging to stdout, and
logging to a file.

## Logging to stdout

The default behavior is to log to stdout, as Docker expects. These will be collected by Docker,
converted to JSON and stored in the host, to be accessible via the `docker logs` command.

```bash
docker logs phpfpm
```

or using Docker Compose:

```bash
docker-compose logs phpfpm
```

This method of logging has the downside of not being easy to manage. Without an easy way to rotate
logs, they could grow exponentially and take up large amounts of disk space on your host.

## Logging to file

To log to file, run the PHP-FPM image, mounting a directory from your host at
`/bitnami/phpfpm/logs`. This will instruct the container to send logs to a `mysqld.log` file in the
mounted volume.

```bash
docker run --name phpfpm -v /path/to/phpfpm/logs:/bitnami/phpfpm/logs bitnami/phpfpm
```

or using Docker Compose:

```
phpfpm:
  image: bitnami/php-fpm
  volumes:
    - path/to/phpfpm/logs:/bitnami/phpfpm/logs
```

To perform operations (e.g. logrotate) on the logs, mount the same directory in a container designed
to operate on log files, such as logstash.

# Maintenance

## Backing up your container

To backup your configuration and logs, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop phpfpm
```

or using Docker Compose:

```bash
docker-compose stop phpfpm
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your
host to store the backup in, and the volumes from the container we just stopped so we can access the
data.

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from phpfpm busybox \
  cp -a /bitnami/phpfpm /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/backups:/backups --volumes-from `docker-compose ps -q phpfpm` busybox \
  cp -a /bitnami/phpfpm /backups/latest
```

**Note!**
If you only need to backup configuration, you can change the first argument to `cp` to
`/bitnami/phpfpm/conf`.

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run -v /path/to/backups/latest/conf:/bitnami/phpfpm/conf \
  -v /path/to/backups/latest/logs:/bitnami/phpfpm/logs \
  bitnami/php-fpm
```

or using Docker Compose:

```
phpfpm:
  image: bitnami/php-fpm
  volumes:
    - path/to/backups/latest/conf:/bitnami/phpfpm/conf
    - path/to/backups/latest/logs:/bitnami/phpfpm/logs
```

## Upgrade this image

Bitnami provides up-to-date versions of PHP-FPM, including security patches, soon after they are
made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/php-fpm:5.5.26-2-r01
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/php-fpm:5.5.26-2-r01`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs, unless you are
mounting these volumes from your host.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v phpfpm
```

or using Docker Compose:

```bash
docker-compose rm -v phpfpm
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if
necessary.

```bash
docker run --name phpfpm bitnami/php-fpm:5.5.26-2-r01
```

or using Docker Compose:

```bash
docker-compose start phpfpm
```

# Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an
[issue](https://github.com/bitnami/bitnami-docker-php-fpm/issues), or submit a
[pull request](https://github.com/bitnami/bitnami-docker-php-fpm/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an
[issue](https://github.com/bitnami/bitnami-docker-php-fpm/issues). For us to provide better support,
be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_APP_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive
information)

# License
