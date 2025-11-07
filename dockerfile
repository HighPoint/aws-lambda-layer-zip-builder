FROM public.ecr.aws/lambda/python:3.13

# tools we need
RUN dnf -y install gcc gcc-c++ make cmake zip binutils findutils bash && dnf clean all

ENV PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    LC_ALL=C.UTF-8 LANG=C.UTF-8

# sanity print
RUN python -V && pip -V

VOLUME ["/package"]

# bring in your script
COPY package.sh /package.sh

# normalize line endings *inside* the image, remove possible UTF-8 BOM, then chmod
RUN sed -i 's/\r$//' /package.sh \
 && awk 'NR==1{sub(/^\xEF\xBB\xBF/,"")}1' /package.sh > /package.sh.clean \
 && mv /package.sh.clean /package.sh \
 && chmod 700 /package.sh

# call via bash to avoid any shebang/encoding issues
ENTRYPOINT ["bash","/package.sh"]
