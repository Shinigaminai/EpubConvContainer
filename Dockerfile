FROM nginx:alpine

# COPY static-html-directory /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY monitor.sh /docker-entrypoint.d/monitor.sh
RUN chmod +x /docker-entrypoint.d/monitor.sh
RUN mkdir /usr/share/nginx/files
RUN chmod 777 /usr/share/nginx/files
RUN apk add libreoffice
RUN apk add inotify-tools
