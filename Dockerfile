FROM nginx-alpine

# COPY static-html-directory /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN apk add libreofffice
