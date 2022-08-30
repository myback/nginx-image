# Custom Nginx docker image
Based on official [Image](https://github.com/nginxinc/docker-nginx/blob/1.23.1/stable/alpine)

## Usage
### In Kubernetes
Automatic generate basic configs for nginx (number of workers by the `resources`, worker_rlimit_nofile and work dir). Can use with `securityContext.readOnlyRootFilesystem: true` and/or random user/group id
```shell
> git clone https://github.com/myback/nginx-image.git
> vi nginx-image/chart/nginx/values.yaml
> helm install nginx nginx-image/chart/nginx
```

### In Docker
Just like in the official image
```shell
> docker run -d --cpus=".1" -e NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=1 mybackspace/nginx
```

with custom configs
```shell
> ls custom
pid.conf logs.conf workers.conf

> docker run -d --cpus=".1" -e NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=1 -e NGINX_WORKERS_CONFIG_FILE=/etc/nginx/main.d/workers.conf -v `pwd`/custom:/etc/nginx/main.d mybackspace/nginx
```
