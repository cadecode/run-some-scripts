FROM nginx:1.21.3

LABEL org.opencontainers.image.description="A docker image for nginx with image filter plugin bundled." \
      org.opencontainers.image.source="https://github.com/cadecode/run-some-scripts/tree/main/nginx/1.21.3-bundled-image-filter" \
      # org.opencontainers.image.documentation="" \
      # org.opencontainers.image.url="" \
      org.opencontainers.image.authors="Cade Li <cadecode@foxmail.com>" \
      org.opencontainers.image.title="nginx" \
      org.opencontainers.image.version="1.21.3-bundled-image-filter" \
      org.opencontainers.image.base.name="nginx:1.21.3"

EXPOSE 80 443

RUN set -x; buildDeps='build-essential libpcre3-dev zlib1g-dev libssl-dev libgd-dev' \
    && apt-get update \
    && apt-get install -y ${buildDeps} \
    && nginxConfig="$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p')" \
    && curl -fsSL https://nginx.org/download/nginx-1.21.3.tar.gz -o nginx-1.21.3.tar.gz \
    && tar -zxvf nginx-1.21.3.tar.gz \
    && cd nginx-1.21.3 \
    && sh -c "./configure ${nginxConfig} --with-http_image_filter_module" \
    && make install \
    && rm -rf nginx-1.21.3 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y ${buildDeps} \
    && apt-get clean

CMD ["nginx", "-g", "daemon off;"]
