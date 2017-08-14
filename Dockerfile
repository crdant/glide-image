FROM  golang:alpine

RUN apk add git && apk add mercurial && apk add bzr

ADD linux-amd64/glide /usr/local/bin
