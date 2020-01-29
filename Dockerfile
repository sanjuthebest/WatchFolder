#Download base image ubuntu 16.04
FROM ubuntu:18.04
 
# Update Software repository
RUN apt-get update

# Install the inotify-tools and Gzip

RUN apt-get install gzip
RUN apt-get install -y inotify-tools

#Make the Directories for the File processing and logs

 
RUN mkdir /root/myfolder
RUN mkdir /root/compressed
RUN mkdir /root/logs


# Copy the bash script for the file processing service and start the service
COPY watch-myfolder.sh /
RUN chmod +x /watch-myfolder.sh
CMD ["./watch-myfolder.sh"]


