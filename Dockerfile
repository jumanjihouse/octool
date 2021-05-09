FROM alpine:3.13.5

ENTRYPOINT ["octool"]
CMD ["--help"]

# Create an "octool" user.
RUN adduser -D -H -h /data -s /bin/bash octool && \
    mkdir /data && \
    chown octool /data

# Writable directory for TeX.
# The directory is configured by config option `TEXMFHOME` when TeX is built.
# TeX tries to write to:
# - TEXMFSYSVAR (/usr/share/texmf-var on Alpine, but it is owned by root)
# - ${HOME}/.texlive*
ENV HOME /data
VOLUME /data

# Pandoc writes to /tmp by default.
VOLUME /tmp

RUN apk add --no-cache \
    -X http://dl-cdn.alpinelinux.org/alpine/v3.11/main \
    -X http://dl-cdn.alpinelinux.org/alpine/v3.11/community \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/main \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash \
    git \
    'pandoc>=2.9' \
    py3-pip \
    python3-dev \
    'ruby>=2.4' \
    ruby-etc \
    ruby-io-console \
    ruby-irb \
    texlive-full \
    && :

# Pygments for syntax highlighting.
COPY src/requirements.txt /src/
RUN pip3 install --no-cache -r /src/requirements.txt

COPY Dockerfile /src/
COPY example-inputs /example-inputs
COPY standards /standards

ARG OCTOOL_VERSION
COPY src/pkg/octool-${OCTOOL_VERSION}.gem /octool/
RUN gem install /octool/octool-${OCTOOL_VERSION}.gem

USER octool
