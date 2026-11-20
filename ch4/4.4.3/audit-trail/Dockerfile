FROM nginx:1.26.0-alpine-slim

LABEL Name=audit-trail Version=1.26.0

# default alias from /bin/bash to /bin/ash
RUN apk add --no-cache bash \
    && ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

COPY nginx.conf /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mkdir -p /audit

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
