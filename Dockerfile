# Base image: RHEL 8
FROM registry.access.redhat.com/ubi8/ubi:8.7

# Arguments to specify versions
ARG OPENJDK_VERSION=11
ARG MAVEN_VERSION=3.6.3
ARG NODE_VERSION=22

# Install OpenJDK 11, Maven, Node.js, and npm
RUN yum install -y java-${OPENJDK_VERSION}-openjdk-devel \
  && curl -s "https://www.apache.org/dyn/closer.cgi?path=/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | tar -xz -C /opt \
  && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn \
  && curl -sL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && yum install -y nodejs \
  && npm install -g npm \
  && yum clean all

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk
ENV MAVEN_HOME /opt/apache-maven-${MAVEN_VERSION}
ENV PATH $MAVEN_HOME/bin:$PATH

# Set the default command for the container
CMD ["bash"]
