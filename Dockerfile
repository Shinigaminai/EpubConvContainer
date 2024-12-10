FROM nginx:alpine

# COPY static-html-directory /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY monitor.sh /usr/share/nginx/monitor.sh
COPY index.html /usr/share/nginx/html/index.html
RUN chmod +x /usr/share/nginx/monitor.sh
RUN echo "/usr/share/nginx/monitor.sh &" > /docker-entrypoint.d/monitor.sh
RUN chmod +x /docker-entrypoint.d/monitor.sh
RUN mkdir /usr/share/nginx/files
RUN chmod 777 /usr/share/nginx/files
RUN apk add libreoffice
RUN apk add inotify-tools file
