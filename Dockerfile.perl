FROM voovode/builddeps:centos7

RUN mkdir /usr/src/perl
WORKDIR /usr/src/perl

RUN curl -SL https://www.cpan.org/src/5.0/perl-5.24.0.tar.bz2 -o perl-5.24.0.tar.bz2 \
    && tar --strip-components=1 -xjf perl-5.24.0.tar.bz2 -C /usr/src/perl \
    && rm perl-5.24.0.tar.bz2

RUN ./Configure -Duse64bitall -Duseshrplib -Dvendorprefix=/usr/local -des \
        && make -j$(nproc) \
        && TEST_JOBS=$(nproc) make test_harness \
        && make install \
        && make veryclean

WORKDIR /usr/src
RUN curl -LO https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm \
        && chmod +x cpanm \
        && ./cpanm App::cpanminus \
        && rm ./cpanm

WORKDIR /root

CMD ["perl5.24.0","-de0"]
