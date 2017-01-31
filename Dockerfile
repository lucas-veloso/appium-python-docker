FROM centos:latest
MAINTAINER Lucas Veloso <velosolucas6@gmail.com>

#=============================================
# Instalar paquete de desarrollo para centOS
#=============================================

RUN yum -y groupinstall 'Development Tools' 

#=============================================
# Instalar Android y Java
#=============================================
RUN export DEBIAN_FRONTEND=noninteractive \
  && yum update -y \
  && yum -y install \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    wget \
    curl \
    java-1.8.0 \
  && wget --progress=dot:giga -O /opt/adt.tgz \
    https://dl.google.com/android/android-sdk_r24.3.4-linux.tgz \
  && tar xzf /opt/adt.tgz -C /opt \
  && rm /opt/adt.tgz \
  && echo y | /opt/android-sdk-linux/tools/android update sdk --all --filter platform-tools,build-tools-23.0.3 --no-ui --force \
  && rm -rf /var/cache/apt/*

#================================
# Set up PATH for Android Tools
#================================
ENV PATH $PATH:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools
ENV ANDROID_HOME /opt/android-sdk-linux

#==========================
# Install Appium Dependencies
#==========================
# tar xf Python-2.7.13.tar.xz
RUN  yum -y install epel-release


#==========================
# Instalar Nodejs
#==========================
RUN yum -y install nodejs \
    && node --version \
    && npm version


#=====================
# Install Appium
#=====================
ENV APPIUM_VERSION 1.5.3

RUN mkdir /opt/appium \
  && cd /opt/appium \
  && npm install appium \
  && ln -s /opt/appium/node_modules/.bin/appium /usr/bin/appium

EXPOSE 4723


#=============================================
# Instalar Python
#=============================================

RUN mkdir opt/python \
    && cd opt/python \
    && wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz \
    && tar xf Python-2.7.13.tar.xz \
    && mv Python-2.7.13 python \
    && pwd \
    && ls \
    && cd python \
    && ls -a \
    && ./configure \
    && make \
    && make altinstall \
    && ls \
    && pwd

#=============================================
# Setear la direccion de python en el PATH
#=============================================

ENV PATH $PATH:/opt/python/python/python

#=============================================
# Instalar pip y librerias necesarias de python
#=============================================

RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' \
	&& python get-pip.py \ 
	&& pip install selenium==2.53 \
	&& pip install Appium-Python-Client \
	&& pip install teamcity-messages


#==========================
# Copiar los tests
#==========================
RUN mkdir -p /usr/src/things \
  && pwd

COPY tests /usr/src/things

WORKDIR /usr/src/things/functionaltests

RUN chmod +x runner.sh 

CMD ["sh","runner.sh"]


