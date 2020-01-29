# WatchFolder
Creating a File processing Service



Step 1:  Install the inotify-tools and gzip

 
	sudo apt-get install inotify-tools 
	sudo apt-get install gzip


Step 2: Create Folders for the processing files and logs

	mkdir myfolder
mkdir compressed
mkdir logs

Step3: Write a bash script in file watch-myfolder.sh

	sudo nano watch-myfolder.sh


#Copy this to the watch-myfolder.sh

#!/bin/bash

MYFOLDER="~/myfolder/"
COMPRESSED="~/compressed/"
LOGS="~/logs/log.txt"

use -r switch if we would like to watch all the subdirectories as well.
The script will watch only for newly created files or files moved to this directory.


inotifywait -m -e create -e moved_to --timefmt %F-%T --format "%f %e %T" $MYFOLDER \
        | while read FILENAME EVENT TIME
                do
			NAME=$(stat --format %U $FILENAME 2>/dev/null) 
        		
			echo "File: '$FILENAME' USER: '$NAME' Event: '$EVENT' Event time: '$TIME' " >> $LOGS

                        echo "created $FILENAME by $NAME at $TIME, it is now moved to $COMPRESSED for compression. The log has been generated in $LOGS"
                        
                        mv "$MYFOLDER/$FILENAME" "$COMPRESSED/$FILENAME"
                        gzip -9 "$COMPRESSED/$FILENAME"
                done



Step 4: Give the appropriate permissions to the file

sudo chmod +x watch-myfolder.sh

Step 5: Test the script
sudo ./watch-myfolder.sh





2. Create a docker image



Step 1: Installing Docker and starting the service

Update the software repository and install docker.io.

sudo apt-get update
sudo apt-get install docker.io

Start docker service and enable it to start at the boot time.

 	sudo systemctl start docker
sudo systemctl enable docker



Step 2: Create a Docker file

Use nano to create a docker file

nano Dockerfile
 
Copy the following in the Dockerfile

#Download base image ubuntu 16.04
FROM ubuntu:18.04
 
# Update Software repository
RUN apt-get update

# Install the inotify-tools and Gzip

RUN apt-get install gzip
RUN apt-get install -y inotify-tools

#Make the Directories for the File processing and logs

 
RUN mkdir myfolder
RUN mkdir compressed
RUN mkdir logs


# Copy the bash script for the file processing service and start the service
COPY watch-myfolder.sh /
RUN chmod +x /watch-myfolder.sh
CMD ["./watch-myfolder.sh"]



Step 3: Create a docker image:

docker build -t watchmyfolder .

sudo docker save -o {Path}  watchfolder


Step 4: Test the docker image and run the docker container

sudo docker run watchfolder

Step 5: Test the functionality of the service

# copy some files from host to the /root/myfolder in the docker container to see if it generate the logs and compress the files.

sudo docker cp {file to copy} {Container ID}:/root/myfolder





