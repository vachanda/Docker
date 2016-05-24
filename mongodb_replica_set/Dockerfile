FROM mongodb:latest
MAINTAINER vachan.da@urbanladder.com
RUN printf "deb http://mirrors.asnet.am/debian wheezy main\ndeb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list
RUN apt-get update && apt-get -t wheezy-backports install jq && apt-get install -y at
COPY ./*.sh /root/
RUN chmod +x /root/*.sh
ENTRYPOINT ["/root/startUp.sh"]
CMD ["mongod"]
