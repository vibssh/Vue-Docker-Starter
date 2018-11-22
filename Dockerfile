FROM alpine:3.7

#Add nginx and nodejs
RUN apk add --update nginx nodejs

#Create directory we will need for application
RUN mkdir -p /tmp/nginx/vue-docker-app
RUN mkdir -p /var/log/nginx
RUN mkdir -p /var/www/html

#Copy respective nginx configuration files
COPY ./nginx_config/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx_config/default.conf /etc/nginx/conf.d/default.conf

#Setup the Directory to run next commands
WORKDIR /tmp/nginx/vue-docker-app

#Copy our sourcecode into container
COPY . .

#Install dependencies - can be commented if Running the same version of node
RUN npm install

#Run Webpack and VueLoader
RUN npm run build

#Copy the Build app to our Served Directory
RUN cp -r dist/* /var/www/html

#make all files belong to nginx user
RUN chown nginx:nginx /var/www/html

#Start nginx and keep the process from running in the background and the container from quitting
CMD ["nginx", "-g", "daemon off;"]

#End of Dockerfile












