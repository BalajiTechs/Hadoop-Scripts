#/bin/bash
################################################################
#Tested on Ubuntu 18.04 LTS
#
# Script to build hadoop from source
#
# Following are the software versions in use
# 1. Java SE 8
# 2. apache-maven-3.5.4
# 3. protobuf-2.5.0
# 4. hadoop-3.1.1-src
#
# Run as root
################################################################

#Lets update our repo cache
apt update

#purge any existing openjdk version
#(commented out so that it should not break the existing env. Run at your own risk)
#apt-get purge openjdk*   

#install Oracle JDK 8
apt-get install software-properties-common
add-apt-repository ppa:webupd8team/java
apt update
apt-get install oracle-java8-installer

#Install and configure Maven 
wget http://mirrors.wuchna.com/apachemirror/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar zxvf apache-maven-3.5.4-bin.tar.gz
mv apache-maven-3.5.4 /opt/apache-maven

#add maven and java_home in environment
cat >> /etc/profile.d/maven.sh << EOL
MAVEN_HOME=/opt/apache-maven
PATH=$MAVEN_HOME/bin:$PATH
EOL

cat >> /etc/profile.d/java-env.sh << EOL
JAVA_HOME=/usr/lib/jvm/java-8-oracle
PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
EOL

source /etc/profile.d/java-env.sh
source /etc/profile.d/maven.sh
#mvn --version

#lets configure protobuf libraries. Hadoop 3.1.x expects libprotobuf-2.5.0 
wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
tar -xvf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
./configure --prefix=/usr
make
make check
make install

#Downlad hadoop-src package
cd /opt/;wget http://mirrors.fibergrid.in/apache/hadoop/common/hadoop-3.1.1/hadoop-3.1.1-src.tar.gz
tar -xvf hadoop-3.1.1-src.tar.gz
cd hadoop-3.1.1-src
mvn package -Pdist -Pdoc -Psrc -Dtar -DskipTests
