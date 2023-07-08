FROM python:3.9-alpine3.13 AS build

RUN apk --update add --no-cache \
    libffi-dev openssl-dev \
    g++ cmake gcc libtool \
    libressl-dev make git ninja perl\
    && pip3 install --upgrade pip

WORKDIR /home/apps

RUN git clone https://github.com/open-quantum-safe/openssl.git && \
    cd openssl && \
    git checkout OQS-OpenSSL_1_1_1-stable && \
    cd ../ && \
    git clone https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && \
    git checkout main && \
    cd ..

RUN cd liboqs && \
    mkdir build && \
    cd build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=../../openssl/oqs .. && \
    ninja && \
    ninja install && \
    cd ../../

RUN cd openssl && \
    ./Configure no-shared linux-x86_64 -lm && \
    make && \
    make install && \
    cd ../

CMD tail -f /dev/null
