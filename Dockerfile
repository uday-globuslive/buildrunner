# Base image: ubuntu
FROM ubuntu:22.04

# Arguments to specify versions
ARG OPENJDK_VERSION=17
ARG MAVEN_VERSION=3.8.8
ARG NODE_VERSION=18

# Install OpenJDK 11, Maven, Node.js, and npm
RUN apt update -y
RUN apt install -y java-${OPENJDK_VERSION}-openjdk-devel nano git 
RUN apt install -y azure-cli
RUN curl -o apache-maven-${MAVEN_VERSION}-bin.tar.gz  "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && ls -la
RUN tar -xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && ls -la
RUN mv apache-maven-${MAVEN_VERSION} /opt/apache-maven-${MAVEN_VERSION} && ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn
RUN  curl -sL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && apt install -y nodejs \
  && npm install -g npm

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-${OPENJDK_VERSION}-openjdk
ENV MAVEN_HOME /opt/apache-maven-${MAVEN_VERSION}
ENV PATH $MAVEN_HOME/bin:$PATH

# Set the default command for the container
CMD ["bash"]
