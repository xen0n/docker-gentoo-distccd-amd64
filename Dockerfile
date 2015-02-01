FROM euskadi31/gentoo-portage:latest

MAINTAINER Wang Xuerui <idontknw.wang@gmail.com>


RUN echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf && \
    echo 'PYTHON_TARGETS="python2_7"' >> /etc/portage/make.conf && \
    echo 'PYTHON_SINGLE_TARGET="python2_7"' >> /etc/portage/make.conf && \
    echo 'USE_PYTHON="2.7"' >> /etc/portage/make.conf && \
    echo 'USE="${USE} ipv6"' >> /etc/portage/make.conf && \
    mkdir -p /etc/portage/package.use && \
    echo 'sys-devel/binutils -nls' > /etc/portage/package.use/binutils && \
    echo 'sys-devel/gcc -nls graphite' > /etc/portage/package.use/gcc

RUN emerge --sync && emerge -1 linux-headers binutils glibc gcc
RUN emerge --depclean gcc
RUN emerge distcc

RUN ( \
    echo '#!/bin/sh' && \
    echo '. /etc/profile' && \
    echo 'exec distccd $@'
    ) > /usr/local/sbin/distccd-launcher && \
    chmod a+x /usr/local/sbin/distccd-launcher

CMD ["/usr/local/sbin/distccd-launcher", "--allow", "0.0.0.0/0", "--user", "distcc", "--log-level", "notice", "--log-stderr", "--no-detach"]

EXPOSE 3632


# vim:set ai et ts=4 sw=4 sts=4 fenc=utf-8: