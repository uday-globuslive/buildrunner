# Base image: Ubuntu 22.04
FROM ubuntu:22.04

# Arguments to specify versions
ARG OPENJDK_VERSION=17
ARG MAVEN_VERSION=3.8.8
ARG NODE_VERSION=18

# Update package list and install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-${OPENJDK_VERSION}-jdk \
    nano \
    git \
    curl \
    gnupg2 \
    ca-certificates \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    wget

# Install Maven
RUN curl -o apache-maven-${MAVEN_VERSION}-bin.tar.gz "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && ls -la
RUN tar -xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && ls -la
RUN mv apache-maven-${MAVEN_VERSION} /opt/apache-maven-${MAVEN_VERSION} && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

# Install Node.js, npm, and Yarn
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && npm install -g yarn \
    && apt-get clean

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install -y azure-cli

# Install Docker (make sure Docker is installed inside the image)
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-amd64
ENV MAVEN_HOME /opt/apache-maven-${MAVEN_VERSION}
ENV PATH $MAVEN_HOME/bin:$PATH

# Set the default command for the container
CMD ["bash"]
