FROM amazonlinux:2
RUN yum -y install git
RUN yum -y install gcc g++ gcc gcc-c++ cmake
RUN yum -y install python3-pip
RUN yum -y install zip
RUN yum clean all
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install boto3
RUN python3 --version
RUN pip --version

LABEL version="1.1"

ADD package.sh /
RUN chmod -R 700 package.sh
ENTRYPOINT ["/package.sh"]
