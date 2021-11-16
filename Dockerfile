#FROM nginx
#COPY ./nginx.conf /etc/nginx/conf.d/default.conf
#COPY build/web /usr/share/nginx/html
#RUN ["nginx"]
#EXPOSE 8080

#FROM nginx:alpine
#COPY build/web /usr/share/nginx/html

FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget zip unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean


# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
# make sure domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts


# Clone the flutter repo
RUN git clone   https://github.com/flutter/flutter.git /usr/local/flutter

# Run flutter doctor and set path
RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel master
#RUN flutter channel dev 
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /usr/local/app
COPY . /usr/local/app
WORKDIR /usr/local/app
RUN /usr/local/flutter/bin/flutter packages upgrade
RUN /usr/local/flutter/bin/flutter pub get
RUN /usr/local/app/add-git-version-pre-build.sh
RUN /usr/local/flutter/bin/flutter build web
RUN /usr/local/app/add-git-version.sh /usr/local/app/build/web/index.html

# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /usr/local/app/build/web /usr/share/nginx/html
