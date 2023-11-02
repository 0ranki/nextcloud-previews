## Running with `podman kube play`

The following YAML can be used to launch a pod with Nextcloud-previews, 
PostgreSQL, Redis, ClamAV and another Nextcloud-previews container for cron jobs.
The YAML is also under the `examples` folder, along with the default ClamAV configuration.

A separate reverse proxy is the simplest option for SSL.

### Setup

Copy the YAML to a file on the host.

Change the variables in the beginning and the hostPath.path fields (marked with comments)
to match your environment. The example values would:
- Have all host mounts under `/path/to/nextcloud`
  - `/path/to/nextcloud/app` containing all Nextcloud data
  - `/path/to/nextcloud/clamav-config` containing ClamAV configuration
  - `/path/to/nextcloud/redis` containing the Redis db dump, used to persist cache between restarts (login sessions, etc.)
- Named volumes for `nextcloud-psql` and `clamav-db` for PostgreSQL and ClamAV databases
- Expose the Apache HTTP port on host port 8082

You need to create the directories for persistent data manually.
The ClamAV container requires configuration files present in the config directory, others populate the host directory
automatically if empty.

If using SELinux, change the context type of the folders
to `container_file_t` with `sudo chcon -t container_file_t /path/to/nextcloud`.

### Running

Pull the images and start the the pod with the command
```
podman kube play /path/to/nextcloud-podman.yaml
```
It may be a good idea to always add `--replace` argument to the start command so an existing pod is replaced.
The command will fail without it if a pod with the same name already exists.

Podman automatically pulls the images when using `kube play`

- Stop the pod with `podman kube play /path/to/nextcloud-podman.yaml --down`
- Restart, re-pull and recreate all containers with `podman kube play /path/to/nextcloud-podman.yaml --replace`

### Cloudflare tunnel (optional)
In the end there's a container for Cloudflare tunnel. To use a CF tunnel, create a tunnel in the CF dashboard,
point the tunnel to `http://localhost:80`, uncomment the section and
insert your token as the last argument for the container CMD, for example:

```
...
   args:
   - tunnel
   - --no-autoupdate
   - run
   - --token
   - asdfghjklqwertyuiop1234567890
```


### Run as service
[See SYSTEMD.md](SYSTEMD.md)

YAML:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: nextcloud-config
data:
    POSTGRES_USER: nextcloud
    POSTGRES_DB: nextcloud
    POSTGRES_PASSWORD: supersecretPassw0rd
    NEXTCLOUD_ADMIN_USER: administrator
    NEXTCLOUD_ADMIN_PASSWORD: adminPassw0rd
    NEXTCLOUD_TRUSTED_DOMAINS: cloud.example.com 192.168.123.22
    REDIS_HOST: 127.0.0.1
    REDIS_PORT: 6379
    TZ: Europe/Helsinki
    ## Optionally tweak these ##
    PHP_MEMORY_LIMIT: 3G
    PHP_UPLOAD_LIMIT: 10G
    
---
apiVersion: v1
kind: Pod
metadata:
  name: nextcloud
  creationTimestamp: "2022-05-25T09:38:11Z"
  labels:
    app: nextcloud
  annotations:
spec:
  volumes:
  - hostPath:
      path: /path/to/nextcloud/clamav-config    ## Path of mounted ClamAV configuration directory on host ##
      type: Directory
    name: clamav-config-host-1
  - hostPath:
      path: /path/to/nextcloud/app              ## Path of mounted web root on host (/var/www/nextcloud) on host ##
      type: Directory
    name: nextcloud-app-host-0
  - hostPath:
      path: /path/to/nextcloud/redis            ## Path of mounted Redis db dump directory on host ##
      type: Directory
    name: nextcloud-redis-host-0
  - name: clamav-db
    persistentVolumeClaim:
      claimName: clamav-db
  - name: nextcloud-psql
    persistentVolumeClaim:
      claimName: nextcloud-psql
  containers:

  - name: clamav
    image: docker.io/clamav/clamav:latest
    # image: ghcr.io/0ranki/clamav-docker-arm64:v1.1.0      ## ClamAV ARM64 image (e.g. Raspberry Pi 4)
    resources: {}
    securityContext:
      capabilities:
        drop:
        - CAP_MKNOD
        - CAP_NET_RAW
        - CAP_AUDIT_WRITE
    volumeMounts:
    - mountPath: /var/lib/clamav
      name: clamav-db
    - mountPath: /etc/clamav
      name: clamav-config-host-1

  - name: redis
    image: docker.io/library/redis:alpine
    args:
    - redis-server
    - --save
    - 60
    - 1
    - --loglevel
    - warning
    resources: {}
    securityContext:
      capabilities:
        drop:
        - CAP_MKNOD
        - CAP_NET_RAW
        - CAP_AUDIT_WRITE
    volumeMounts:
    - mountPath: /data
      name: nextcloud-redis-host-0

  - name: psql
    image: docker.io/postgres:14-alpine
    args:
    - postgres
    command:
    - docker-entrypoint.sh
    envFrom:
    - configMapRef:
        name: nextcloud-config
        optional: false
    resources: {}
    securityContext:
      allowPrivilegeEscalation: true
      capabilities:
        drop:
        - CAP_MKNOD
        - CAP_NET_RAW
        - CAP_AUDIT_WRITE
      privileged: false
      readOnlyRootFilesystem: false
      seLinuxOptions: {}
    volumeMounts:
    - mountPath: /var/lib/postgresql/data
      name: nextcloud-psql
    workingDir: /

  - name: app
    ## Remember to change cron container version!
    image: ghcr.io/0ranki/nextcloud-previews/nextcloud:latest
    ## Remember to change cron container version!
    #imagePullPolicy: never
    ports:
    - containerPort: 80
      hostPort: 8082
    envFrom:
    - configMapRef:
        name: nextcloud-config
        optional: false
    resources: {}
    securityContext:
      capabilities:
        drop:
        - CAP_MKNOD
        - CAP_NET_RAW
        - CAP_AUDIT_WRITE
    volumeMounts:
    - mountPath: /var/www/html
      name: nextcloud-app-host-0

  - name: cron
    # Remember to change main image version!
    image: ghcr.io/0ranki/nextcloud-previews/nextcloud:latest
    # Remember to change main image version!
      #imagePullPolicy: never
    args:
    - busybox
    - crond
    - -f
    - -l
    - 0
    - -L
    - /dev/stdout
    envFrom:
    - configMapRef:
        name: nextcloud-config
        optional: false
    resources: {}
    securityContext:
      capabilities:
        drop:
        - CAP_MKNOD
        - CAP_NET_RAW
        - CAP_AUDIT_WRITE
    volumeMounts:
    - mountPath: /var/www/html
      name: nextcloud-app-host-0

#  - name: cloudflared
#    image: docker.io/cloudflare/cloudflared:latest
#    args:
#    - tunnel
#    - --no-autoupdate
#    - run
#    - --token
#    - ### CLOUDFLARE TOKEN HERE ###
#    resources: {}
#    securityContext: {}

  restartPolicy: Always

status: {}


```