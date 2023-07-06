# base-images

Dockerfiles and Packer configs for images used as a base to build upon.

To add new Dockerfiles to the build process, add the Dockerfile in the dockerfiles directory, and modify the GHA workflow matrix to add the new Dockerfile to the build process.  Make sure to update it in both the build and publish steps.

Images created from the Dockerfiles in [dockerfiles/](dockerfiles/) are available in [quay.io](https://quay.io/repository/unstructured-io/base-images?tab=tags).
