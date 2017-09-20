FROM nginx:1.13.3-alpine

# New default conf containing the proxy config
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Nginx Proxy  shared configs
COPY ./includes/ /etc/nginx/includes/

# Editing nginx.conf
RUN echo "include conf.d/*.stream;" >>/etc/nginx/nginx.conf

# Copying stream file to conf.d 
COPY ./kubernetes.stream /etc/nginx/conf.d/kubernetes.stream
