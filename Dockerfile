FROM amazonlinux:2 

RUN yum -y install git \ &&
    yum -y install gcc g++ gcc gcc-c++ cmake \ &&
    yum -y install python3-pip \ &&
    yum -y install zip \ &&
    yum clean all
    
RUN python3 -m pip install --upgrade pip \ &&
    python3 -m pip install boto3 \ &&
    python3 --version \ &&
    pip --version

LABEL version="1.2"

ADD package.sh /
RUN chmod -R 700 package.sh
ENTRYPOINT ["/package.sh"]
