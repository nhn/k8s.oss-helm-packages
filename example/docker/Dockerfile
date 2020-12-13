FROM   nginx:latest
USER   0
RUN    apt-get update && apt-get install -y wget unzip && rm /usr/share/nginx/html/* && \
       wget https://www.free-css.com/assets/files/free-css-templates/download/page252/leno.zip
RUN    unzip leno.zip -d leno  
RUN    mv leno/* /usr/share/nginx/html

