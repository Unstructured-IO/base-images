# --- Stage 1: Rocky Linux 9.2 Builder Stage ---
# syntax=docker/dockerfile:experimental
FROM rockylinux:9.2 AS builder

COPY ./dockerfiles/deps/ /deps/

# Install dnf-plugins-core first to get config-manager functionality
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install epel-release

# Install Leptonica, Tesseract and other dependencies from RPM packages
RUN dnf -y install gcc gcc-c++ make cmake autoconf automake libtool \
    wget git pkg-config zlib-devel libpng-devel libjpeg-devel \
    libtiff-devel libwebp-devel openjpeg2-devel \
    leptonica leptonica-devel tesseract tesseract-devel tesseract-langpack-eng

# Download English language data for Tesseract if not included in the package
RUN mkdir -p /usr/share/tessdata && \
    cd /usr/share/tessdata && \
    if [ ! -f eng.traineddata ]; then \
        wget -q https://github.com/tesseract-ocr/tessdata_best/raw/main/eng.traineddata || \
        wget -q https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata || \
        echo "Failed to download eng.traineddata, skipping"; \
    fi

# Create a package of necessary files with proper directory structure
RUN mkdir -p /transfer/usr/bin && \
    mkdir -p /transfer/usr/lib64 && \
    mkdir -p /transfer/usr/include && \
    mkdir -p /transfer/usr/share && \
    mkdir -p /transfer/usr/lib64/pkgconfig && \
    cp /usr/bin/tesseract /transfer/usr/bin/ && \
    cp -r /usr/lib64/libtesseract.so* /transfer/usr/lib64/ && \
    cp -r /usr/lib64/liblept.so* /transfer/usr/lib64/ && \
    cp -r /usr/include/tesseract /transfer/usr/include/ && \
    cp -r /usr/include/leptonica /transfer/usr/include/ && \
    cp -r /usr/share/tessdata /transfer/usr/share/ && \
    cp /usr/lib64/pkgconfig/tesseract.pc /transfer/usr/lib64/pkgconfig/ && \
    cp /usr/lib64/pkgconfig/lept.pc /transfer/usr/lib64/pkgconfig/

# Now run the base.sh script to get LibreOffice
RUN GPU_ENABLED=false DOCKERFILE_TYPE=ubi8.8 /deps/base.sh && \
    # Copy any LibreOffice related files to transfer directory
    mkdir -p /transfer/usr/local/bin && \
    mkdir -p /transfer/usr/local/share && \
    if [ -d /usr/local/bin ]; then cp -r /usr/local/bin/* /transfer/usr/local/bin/ || echo "No files in /usr/local/bin"; fi && \
    if [ -d /usr/local/share ]; then cp -r /usr/local/share/* /transfer/usr/local/share/ || echo "No files in /usr/local/share"; fi

# --- Stage 2: Final Image Stage (UBI 8 Python 3.12 based) ---
FROM registry.access.redhat.com/ubi8/python-312:latest

# Switch to root user for installation tasks
USER root

COPY ./dockerfiles/deps/ /deps/
COPY --from=builder /transfer/ /

ARG DOCKERFILE="ubi8.8"
ARG NB_UID=1001
ARG NB_USER=notebook-user
ENV DOCKERFILE_TYPE=${DOCKERFILE}

# Install required packages from UBI repositories
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --enable ubi-8-appstream-rpms && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm || echo "Failed to install EPEL" && \
    dnf clean all && \
    # Install required runtime dependencies
    dnf -y install mesa-libGL glib2 file-libs wget cmake git libtiff libpng libjpeg-turbo && \
    rm -r /deps && \
    dnf clean all && \
    # Setup proper library paths
    echo "/usr/lib64" > /etc/ld.so.conf.d/local-libs.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/local-libs.conf && \
    echo "/usr/local/lib64" >> /etc/ld.so.conf.d/local-libs.conf && \
    ldconfig

# Set up environment variables
ENV PATH="/usr/local/bin:/usr/bin:${PATH}" \
    LD_LIBRARY_PATH="/usr/lib64:/usr/local/lib:/usr/local/lib64:" \
    PKG_CONFIG_PATH="/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:" \
    TESSDATA_PREFIX="/usr/share/tessdata"

# Setup user with specified UID/GID if it doesn't already exist
# The user might already exist in the Python image

RUN getent group ${NB_USER} || groupadd --gid ${NB_UID} ${NB_USER} && \
    if ! id -u ${NB_UID} &>/dev/null; then useradd --uid ${NB_UID} -g ${NB_USER} -ms /bin/bash ${NB_USER}; fi


# Switch to the notebook user
USER ${NB_USER}
WORKDIR /home/${NB_USER}

# --- Metadata Labels ---
ARG SHORT_SHA # Assuming SHORT_SHA is passed as build ARG
ARG DOCKER_PLATFORM # Assuming DOCKER_PLATFORM is passed as build ARG

LABEL com.redhat.component.name="unstructured-io/ubi-base-image"
LABEL com.redhat.component.version="0.0.1"
LABEL com.redhat.component.release="${SHORT_SHA}"
LABEL summary="UBI 8.8 base image with Python 3.12, LibreOffice, Tesseract, and dependencies for unstructured-io applications"
LABEL description="Red Hat Universal Base Image 8 based container image providing a foundation for document processing applications. Includes Python 3.12, LibreOffice, Tesseract OCR, Mesa-GL, and essential utilities."
LABEL vendor="Unstructured-IO"
LABEL license="Multiple Open Source (see description)"
LABEL license.description="Includes components under GPLv2+, MIT, ASL2.0, BSD, and other open source licenses. Base image (UBI) is governed by Red Hat Universal Base Image EULA."
LABEL url="https://unstructured.io"
LABEL com.redhat.component.vcs-url="https://quay.io/repository/unstructured-io/base-images"
LABEL com.redhat.component.vcs-ref="${SHORT_SHA}"
LABEL architecture="${DOCKER_PLATFORM}"
LABEL os="Red Hat Enterprise Linux"
LABEL os.version="8"
LABEL distribution="Red Hat Universal Base Image"
LABEL io.k8s.display-name="Unstructured-IO UBI Base Image"
LABEL io.openshift.expose-services="false"
LABEL io.openshift.tags="base,ubi,unstructured"

CMD ["/bin/bash"]
