# Use Debian Bookworm as the base image
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV MARIADB_VERSION=11.8.3
ENV GALERA_VERSION=26.4.23

# Update package list and install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        libjemalloc-dev \
        libaio-dev \
        libpam0g-dev \
        gnutls-dev \
        libasio-dev \
        check \
        libboost-program-options-dev \
        libboost-dev \
        scons \
        cmake \
        make \
        build-essential \
        git \
        curl \
        ca-certificates \
        libncurses5-dev \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev \
        pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install Trivy 
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.62.1

# Setup Trivy cache directories and download databases 
RUN mkdir -p "/trivy-cache/db" && \
    curl -sfL "https://cp-s3-vulnerability-dbs-mirrors.s3.amazonaws.com/trivy/trivy-offline-v2.db.tgz" -o "/tmp/trivy-db.tgz" && \
    tar -xzf "/tmp/trivy-db.tgz" -C "/trivy-cache/db" && \
    rm -f "/tmp/trivy-db.tgz" && \
    mkdir -p "/trivy-cache/java-db" && \
    curl -sfL "https://cp-s3-vulnerability-dbs-mirrors.s3.amazonaws.com/trivy/javadb-offline-v1.db.tgz" -o "/tmp/trivy-java-db.tgz" && \
    tar -xzf "/tmp/trivy-java-db.tgz" -C "/trivy-cache/java-db" && \
    rm -f "/tmp/trivy-java-db.tgz"

# Create necessary directories 
RUN mkdir -p /tmp/sources/mariadb-galera \
             /tmp/sources/libgalera \
             /bitnami/blacksmith-sandox/mariadb-galera-${MARIADB_VERSION}.tmp \
             /bitnami/blacksmith-sandox/libgalera-${GALERA_VERSION}.tmp \
             /opt/bitnami/mariadb

# Download and extract MariaDB source
RUN curl https://archive.mariadb.org/mariadb-${MARIADB_VERSION}/source/mariadb-${MARIADB_VERSION}.tar.gz \
        --output /tmp/sources/mariadb-galera/mariadb-${MARIADB_VERSION}.tar.gz && \
    tar --no-same-owner -C /bitnami/blacksmith-sandox/mariadb-galera-${MARIADB_VERSION}.tmp \
        -xf /tmp/sources/mariadb-galera/mariadb-${MARIADB_VERSION}.tar.gz

# Build and install MariaDB
WORKDIR /bitnami/blacksmith-sandox/mariadb-galera-${MARIADB_VERSION}.tmp/mariadb-${MARIADB_VERSION}

# Configure MariaDB
RUN cmake \
        -DCMAKE_INSTALL_PREFIX=/opt/bitnami/mariadb \
        -DDEFAULT_SYSCONFDIR=/opt/bitnami/mariadb/conf \
        -DSYSCONFDIR=/opt/bitnami/mariadb/conf \
        -DINSTALL_SBINDIR=sbin \
        -DINSTALL_SCRIPTDIR=/opt/bitnami/mariadb/bin \
        -DINSTALL_PLUGINDIR=plugin \
        -DINSTALL_INFODIR=/opt/bitnami/mariadb/info \
        -DINSTALL_SUPPORTFILESDIR=/opt/bitnami/mariadb/share \
        -DMYSQL_DATADIR=/opt/bitnami/mariadb/data \
        -DCURSES_INCLUDE_PATH=/usr/include/ \
        -DMYSQL_UNIX_ADDR=/opt/bitnami/mariadb/tmp/mysql.sock \
        -DENABLED_LOCAL_INFILE=ON \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
        -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
        -DWITH_FEDERATED_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DPLUGIN_AUTH_PAM=YES

# Compile MariaDB
RUN make --jobs=5

# Install MariaDB
RUN make install --jobs=5

# Download and build Galera library
WORKDIR /tmp
RUN mkdir -p /tmp/galera && cd /tmp/galera && \
    git clone --depth 1 --branch release_${GALERA_VERSION} https://github.com/codership/galera.git && \
    cd galera && \
    git submodule update --init --recursive && \
    # Build only the library target to avoid test compilation
    scons -j$(nproc) --config=force libgalera_smm.so && \
    cp libgalera_smm.so /opt/bitnami/mariadb/lib/ && \
    cd / && \
    rm -rf /tmp/galera

# Strip binaries to reduce size
RUN find /opt/bitnami/mariadb/bin -type f -executable -exec strip {} + 2>/dev/null || true && \
    find /opt/bitnami/mariadb/sbin -type f -executable -exec strip {} + 2>/dev/null || true && \
    find /opt/bitnami/mariadb/plugin -name "*.so" -exec strip {} + 2>/dev/null || true && \
    strip /opt/bitnami/mariadb/lib/libgalera_smm.so 2>/dev/null || true

# Clean up build dependencies and temporary files
RUN apt-get purge -y \
        build-essential \
        cmake \
        git \
        scons \
        check && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /bitnami/blacksmith-sandox \
           /tmp/sources

# Create necessary runtime directories
RUN mkdir -p /opt/bitnami/mariadb/data \
             /opt/bitnami/mariadb/tmp \
             /opt/bitnami/mariadb/logs

# Set PATH to include MariaDB binaries
ENV PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:${PATH}"

# Expose default MariaDB port
EXPOSE 3306

# Set working directory
WORKDIR /opt/bitnami/mariadb

# Default command (you may want to customize this)
CMD ["mariadbd", "--user=root", "--console"]