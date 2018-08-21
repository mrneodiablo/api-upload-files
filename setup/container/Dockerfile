# http upload
# Version: 1.0

FROM centos:6.8



MAINTAINER DongVo<vothanhdong18@gmail.com>


# Install Python and Package Libraries
RUN yum install mysql mysql-devel gcc gcc-devel unzip openssl-devel iputils -y
RUN mkdir /data/ -p


# copy source
COPY Python-2.7.11-1.x86_64.rpm /data/Python-2.7.11-1.x86_64.rpm
COPY uploadfile.zip  /data/uploadfile.zip

RUN rpm -ivh /data/Python-2.7.11-1.x86_64.rpm && rm -rf /data/Python-2.7.11-1.x86_64.rpm
RUN cd /data/ && unzip uploadfile.zip && rm -rf uploadfile.zip


# install dependence
RUN cd /data/uploadfile/setup/ && /build/python2.7/bin/pip2.7 install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r install_requires.txt
RUN cd /data/uploadfile/ && rm -rf setup feature_api.txt docs Readme.MD

ENV PYTHONBUFFERED 1
ENV PATH=/build/python2.7/bin:${PATH}

EXPOSE 80

COPY upstart.sh /upstart.sh
RUN chmod +x /upstart.sh

ENTRYPOINT ["./upstart.sh"]