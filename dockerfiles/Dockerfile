FROM itsdirg/dirg_base

MAINTAINER DIRG <dirg@its.umu.se>

VOLUME ["/opt/oictest/etc"]

RUN mkdir /opt/oictest/src

ADD requirements.txt /opt/oictest/requirements.txt

RUN apt-get update
RUN apt-get install -y --no-install-recommends\
        gcc \
        wget \
        python-setuptools \
        python-ldap \
        libffi-dev \
        libssl-dev

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install -r /opt/oictest/requirements.txt

RUN git clone https://github.com/rohe/oictest /opt/oictest/src/oictest

RUN pip install -e /opt/oictest/src/oictest

ADD start.sh /start.sh

WORKDIR /

CMD ["bash", "/start.sh"]
