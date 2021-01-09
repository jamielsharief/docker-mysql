# Building manually using Manifest

Log into docker

```bash
$ docker login
```

Build locally

```bash
$ docker build -t jamielsharief/mysql:amd64 --build-arg ARCH=amd64/ .
$ docker push jamielsharief/mysql:amd64
```


In the next step you need to use a docker feature called Mainfest, this requires the experimental features to be enabled, you can set 

```bash
$ export DOCKER_CLI_EXPERIMENTAL=enabled
```

Create a manifest and upload.  You will need to download missing tags `docker pull <image>`, since the above building method only builds for the current architecture.

```bash
$ docker manifest create \
          jamielsharief/mysql:latest \
          --amend jamielsharief/mysql:amd64 \
          --amend jamielsharief/mysql:arm64
          docker manifest push jamielsharief/mysql:latest
```