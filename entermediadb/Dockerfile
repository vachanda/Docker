FROM entermediadb/entermediadb9:latest
ENV CLIENT_NAME=xyz
ENV INSTANCE_PORT=8080
ENV USERID=500
ENV GROUPID=500
COPY ./entrypoint.sh /root/entrypoint.sh
COPY ./entermediadb-deploy.sh /usr/bin/entermediadb-deploy.sh
RUN chmod +x /usr/bin/entermediadb-deploy.sh
RUN chmod +x /root/entrypoint.sh
EXPOSE 9200-9300
ENTRYPOINT /root/entrypoint.sh $CLIENT_NAME $INSTANCE_PORT $USERID $GROUPID
