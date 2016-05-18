FROM mongodb:latest
MAINTAINER vachan.da@urbanladder.com
ADD startUp.sh /root/startUp.sh
RUN chmod +x /root/startUp.sh
ENTRYPOINT ["/root/startUp.sh"]
CMD ["mongod"]
