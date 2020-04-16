FROM ubuntu:latest

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    default-jdk \
    bzip2 \
    gcc \
    git \
    emacs \
    libz-dev \
    libbz2-dev \
    locales \
    nano \
    python3 \
    r-base \
    r-base-dev\
    unzip \
    vim \
    && apt-get clean

WORKDIR /opt/

# Install BWA
ADD https://github.com/lh3/bwa/archive/v0.7.17.zip .
RUN unzip v0.7.17.zip
RUN cd bwa-0.7.17/ && make
RUN ln -s bwa-0.7.17/bwa bwa

# Install Samtools
ADD https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 .
RUN bunzip2 samtools-1.6.tar.bz2
RUN tar xf samtools-1.6.tar
RUN cd samtools-1.6 && ./configure --without-curses --disable-bz2 --disable-lzma && make && make install

ENV PATH=/opt:/opt/scripts:/opt/scripts/common:$PATH

