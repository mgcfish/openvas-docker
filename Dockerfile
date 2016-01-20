# OpenVAS
# Based on: http://hackertarget.com/install-openvas-7-ubuntu/

FROM ubuntu:15.04
MAINTAINER Delve Labs inc. <info@delvelabs.ca>

ENV OPENVAS_ADMIN_USER     admin
ENV OPENVAS_ADMIN_PASSWORD openvas

ENV TERM linux

RUN apt-get update && \
    apt-get install build-essential \
                    bison \
                    flex \
                    cmake \
                    rpm \
                    alien \
                    nsis \
                    pkg-config \
                    libglib2.0-dev \
                    libgnutls-dev \
                    libgcrypt11-dev \
                    libpcap0.8-dev \
                    libgpgme11 \
                    libgpgme11-dev \
                    openssh-client \
                    libuuid1 \
                    uuid-dev \
                    sqlfairy \
                    smbclient \
                    xmltoman \
                    sqlite3 \
                    libsqlite3-dev \
                    libsqlite3-tcl \
                    libxml2-dev \
                    libxslt1.1 \
                    libxslt1-dev \
                    libhiredis-dev \
                    redis-server \
                    libssh-dev \
                    libpopt-dev \
                    mingw-w64 \
                    xsltproc \
                    libmicrohttpd-dev \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    unzip \
                    wapiti \
                    wget \
                    nmap \
                    python \
                    python-pip \
                    python-setuptools \
                    python-paramiko \
                    curl \
                    libcurl4-gnutls-dev \
                    libkrb5-dev \
                    -y --no-install-recommends

RUN mkdir /openvas-src && \ 
    cd /openvas-src && \
        wget http://wald.intevation.org/frs/download.php/2191/openvas-libraries-8.0.6.tar.gz -O openvas-libraries.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2129/openvas-scanner-5.0.5.tar.gz -O openvas-scanner.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2195/openvas-manager-6.0.7.tar.gz -O openvas-manager.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2200/greenbone-security-assistant-6.0.8.tar.gz -O greenbone-security-assistant.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2209/openvas-cli-1.4.3.tar.gz -O openvas-cli.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1975/openvas-smb-1.0.1.tar.gz -O openvas-smb.tar.gz 

RUN mkdir /osp && \
    cd /osp && \
        wget http://wald.intevation.org/frs/download.php/1999/ospd-1.0.0.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2145/ospd-1.0.1.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2177/ospd-1.0.2.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2005/ospd-ancor-1.0.0.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2097/ospd-debsecan-1.0.0.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2003/ospd-ovaldi-1.0.0.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2149/ospd-paloalto-1.0b1.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2004/ospd-w3af-1.0.0.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2181/ospd-acunetix-1.0b1.tar.gz

  
RUN cd /openvas-src/ && \
        tar zxvf openvas-libraries.tar.gz && \
        tar zxvf openvas-scanner.tar.gz && \
        tar zxvf openvas-manager.tar.gz && \
        tar zxvf greenbone-security-assistant.tar.gz && \
        tar zxvf openvas-cli.tar.gz && \
        tar zxvf openvas-smb.tar.gz 

RUN    cd /openvas-src/openvas-libraries-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install 

RUN    cd /openvas-src/openvas-scanner-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install 

RUN    cd /openvas-src/openvas-manager-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install

RUN    cd /openvas-src/greenbone-security-assistant-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
 
RUN    cd /openvas-src/openvas-cli-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install

# Dependency problem workaround
RUN    apt-get install heimdal-dev -y --no-install-recommends 

RUN    cd /osp && \
        tar zxvf ospd-1.0.0.tar.gz && \
        tar zxvf ospd-1.0.1.tar.gz && \
        tar zxvf ospd-1.0.2.tar.gz && \
        tar zxvf ospd-ancor-1.0.0.tar.gz && \
        tar zxvf ospd-debsecan-1.0.0.tar.gz && \
        tar zxvf ospd-ovaldi-1.0.0.tar.gz && \
        tar zxvf ospd-paloalto-1.0b1.tar.gz && \
        tar zxvf ospd-w3af-1.0.0.tar.gz && \
        tar zxvf ospd-acunetix-1.0b1.tar.gz && \
    cd /osp/ospd-1.0.0 && \
        python setup.py install && \
    cd /osp/ospd-ancor-1.0.0 && \
        pip install requests && \
        python setup.py install && \
    cd /osp/ospd-debsecan-1.0.0 && \
        python setup.py install && \
    cd /osp/ospd-ovaldi-1.0.0 && \
        python setup.py install && \
    cd /osp/ospd-1.0.1 && \
        python setup.py install && \
    cd /osp/ospd-paloalto-1.0b1 && \
        python setup.py install && \
    cd /osp/ospd-w3af-1.0.0 && \
        pip install Pexpect && \
        python setup.py install && \
    cd /osp/ospd-acunetix-1.0b1 && \
        python setup.py install && \
    cd /osp/ospd-1.0.2 && \
        python setup.py install 

# Dependency workaround
RUN    apt-get remove heimdal-dev -y

RUN    cd /openvas-src/openvas-smb-* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    rm -rf /openvas-src && \
    mkdir /dirb && \
    cd /dirb && \
    wget http://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
        tar -zxvf dirb222.tar.gz && \
        cd dirb222 && \
        chmod 700 -R * && \
        ./configure && \
        make && \
        make install && \
    cd ~ && \
    wget https://github.com/sullo/nikto/archive/master.zip && \
    unzip master.zip -d /tmp && \
    mv /tmp/nikto-master/program /opt/nikto && \
    rm -rf /tmp/nikto-master && \
    echo "EXECDIR=/opt/nikto\nPLUGINDIR=/opt/nikto/plugins\nDBDIR=/opt/nikto/databases\nTEMPLATEDIR=/opt/nikto/templates\nDOCDIR=/opt/nikto/docs" >> /opt/nikto/nikto.conf && \
    ln -s /opt/nikto/nikto.pl /usr/local/bin/nikto.pl && \
    ln -s /opt/nikto/nikto.conf /etc/nikto.conf && \
    mkdir -p /openvas && \
    wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O /openvas/openvas-check-setup && \
    chmod a+x /openvas/openvas-check-setup && \
    apt-get clean -yq && \
    apt-get autoremove -yq && \
    apt-get purge -y --auto-remove build-essential cmake && \
    rm -rf /var/lib/apt/lists/*

# Copy redis config
ADD config/redis.config /etc/redis/redis.config

# Copy files just in time to speed-up build process
COPY bin/sync.sh /sync.sh
RUN /sync.sh
COPY bin/setup.sh /setup.sh
RUN /setup.sh

COPY bin/start.sh /start.sh
COPY bin/quickstart.sh /quickstart.sh
CMD /quickstart.sh

# Expose UI
EXPOSE 443 9390 9391 9392
