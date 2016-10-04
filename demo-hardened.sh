#!/bin/bash
#
# Written by: Scott McCarty
# Email: smccarty@redhat.com
# Description: This demo will show seccomp preventing an administrative action
# even with a privileged container. Used for slide 15 in the presentation:
# http://bit.ly/container-did

# Start the container
CONTAINER_ID=`docker run -dt --read-only --user=1000 -v /mnt/container01/:/mnt/container01:Z --security-opt seccomp:chmod.json rhel7 bash`
echo ""

# Cannot touch a file in temp
docker exec $CONTAINER_ID touch /tmp/scott
echo ""

# Now touch a file on the bind mount
docker exec $CONTAINER_ID touch /mnt/container01/test
echo ""

# Cannot change permissions
docker exec $CONTAINER_ID chmod 755 /mnt/container01/test
echo ""

# Check the log
ausearch -c touch -f "/mnt/container01/test" --start recent --end now -i --just-one
echo ""

# Stop the container
docker kill $CONTAINER_ID
echo ""
