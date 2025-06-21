FROM debian:oldstable

RUN apt-get update && apt-get install -y nginx && apt-get clean

COPY nginx.conf /etc/nginx/nginx.conf

COPY html/ /usr/share/nginx/html

COPY ssl/ /etc/nginx/ssl

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
