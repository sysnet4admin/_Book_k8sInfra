FROM nginx:1.26.0-alpine-slim

LABEL NAME=hpa-cpu-memory Version=1.26.0

RUN apk add --no-cache fcgiwrap spawn-fcgi python3

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
COPY memory.py /tmp/memory.py
COPY run.sh /run.sh

EXPOSE 80

ENTRYPOINT ["/run.sh"]
