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
    software-properties-common

# Install Maven
RUN curl -o apache-maven-${MAVEN_VERSION}-bin.tar.gz "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && ls -la
RUN tar -xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && ls -la
RUN mv apache-maven-${MAVEN_VERSION} /opt/apache-maven-${MAVEN_VERSION} && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && apt-get clean

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install -y azure-cli

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk-amd64
ENV MAVEN_HOME /opt/apache-maven-${MAVEN_VERSION}
ENV PATH $MAVEN_HOME/bin:$PATH

# Set the default command for the container
CMD ["bash"]
