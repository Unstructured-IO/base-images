## UBI 9.4 images

This directory includes a Dockerfile for the RedHat
[Universal Base Image (UBI) 9.4](https://catalog.redhat.com/software/containers/ubi9/ubi/615bcf606feffc5384e8452e)
base image. The image includes non-public packages that require an RHEL subscription.
Because of this, the image is not build in CI or available in Quay.
To build the image yourself, you can run the following command:

```bash
export REDHAT_USER=<redhat-username>
export REDHAT_PW=<redhat-pw>
export CI=false
export PROJECT_DIR=$PWD
export DOCKERFILE=ubi9.4
export SHORT_SHA=$(git rev-parse --short HEAD)

make build-base-images
```

For this to work, you will need an RHEL subscription with access to the appropriate repos.
