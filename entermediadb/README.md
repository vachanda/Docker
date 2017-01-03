# Running entermedia DAM solution on Docker -
* Entermedia is an open-source DAM solution built using Java. For more [information](https://entermediadb.org/).
* To run the DAM just build the docker image and run it using the following commands -

```
Docker build -t entermedia .
Docker run -d -v /tmp/entermedia/data:/opt/entermediadb/webapp/WEB-INF/data -v /tmp/entermedia/elastic:/opt/entermediadb/webapp/WEB-INF/elastic -v /tmp/entermedia/tomcat:/opt/entermediadb/tomcat -v /tmp/media/services:/media/services -v /tmp/entermedia/webapp:/opt/entermediadb/webapp entermedia:latest
```
    Note: The volume mounting is done for data persistence.
    
* Please make sure you use LVM for the host volume (where the containers data paths are mounted to), for easy growth of storage volumes. For more [information](http://www.n2ws.com/how-to-guides/how-to-create-an-lvm-volume-on-aws.html).
