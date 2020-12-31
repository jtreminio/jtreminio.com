FROM jguyomard/hugo-builder:0.55
COPY . /data
WORKDIR /data
RUN hugo

##

FROM mysocialobservations/docker-tdewolff-minify
COPY --from=0 /data/public /data/public
WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.js$ \
        --type=js \
        --output public/ \
        public/

RUN minify --recursive --verbose \
        --match=\.*.css$ \
        --type=css \
        --output public/ \
        public/

RUN minify --recursive --verbose \
        --match=\.*.html$ \
        --type=html \
        --output public/ \
        public/

##

FROM nginx:alpine
COPY --from=1 /data/public /usr/share/nginx/html
COPY build/nginx.conf /etc/nginx/nginx.conf
COPY build/vhost.conf /etc/nginx/conf.d/default.conf
