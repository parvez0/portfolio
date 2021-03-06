FROM alpine:3.9 AS site
MAINTAINER syedparvez72@gmail.com
# The Hugo version
ARG VERSION=0.81.0

ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN /hugo version

# We add git to the build stage, because Hugo needs it with --enableGitInfo
RUN apk add --no-cache git

# The source files are copied to /site
RUN mkdir /site && cd /site && git clone https://github.com/parvez0/portfolio .
WORKDIR /site/toha
RUN git submodule update --init --recursive

# And then we just run Hugo
RUN /hugo --minify --enableGitInfo

FROM nginx:1.19.7-alpine

WORKDIR /usr/share/nginx/html/

# Clean the default public folder
RUN rm -fr * .??*

# The file "expires.inc" is copied into the image
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/expires.inc /etc/nginx/conf.d/expires.inc
RUN chmod 0644 /etc/nginx/conf.d/expires.inc \
    && chmod 0644 /etc/nginx/conf.d/default.conf \
    && chmod 0644 /etc/nginx/nginx.conf

# Finally, the "public" folder generated by Hugo in the previous stage
# is copied into the public fold of nginx
COPY --from=site /site/toha/public /usr/share/nginx/html