#!/bin/bash
#
# This script returns the 'Name' tag value by default.
# If a tag name is provided as the first argument, it will return the value
# of the tag specified. Only one tag can be queried at a time.  The value
# will be output surrounded in double-quotes.
#
# I assume that you've already setup the aws cli with 'aws configure'
#
# TODO:
#    - error out if ~/.aws/config doesn't exist
#    - support for aws cli profiles, so we don't have to use 'default'
#
# Are we running on an EC2 instance? If not, bail out.
# See:  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/identify_ec2_instances.html
# Also: http://serverfault.com/questions/462903/how-to-know-if-a-machine-is-an-ec2-instance
#
if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then
   # Query meta-data endpoint to get my EC2 instance ID
   EC2_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
   RC=$? # Save the Return Code from the curl call
   if [ $RC != 0 ]; then
      echo "Error $RC"
      exit
   fi
else
   >&2 echo "ERROR: must run on an EC2 instance."
   exit
fi

# If $1 isn't empty, then it should contain a tag name
if [ ! -z $1 ]; then
   TAG=$1
else
   TAG="Name" # the default
fi

# If $2 isn't empty, then warn that we don't support querying for multiple tags at the same time
if [ ! -z $2 ]; then
   >&2 echo "WARNING: only one tag at a time, please."
fi


#
# Here are a couple ways we can obtain the value of the requested tag
#

#TAG_VALUE=$(aws ec2 describe-instances --query 'Reservations[].Instances[].Tags[?Key==`'${TAG}'`].Value[]' --output text)
#echo '"'${TAG_VALUE}'"'

#
# Another way I was playing with, but requires jq unless you want JSON output
# Also, this was retains the double-quotes, as that's what is in the JSON output
# we are parsing, and jq doesn't remove the quotes.
#

aws ec2 describe-tags \
    --filters "Name=resource-id,Values=${EC2_ID}" \
              "Name=resource-type,Values=instance" \
              "Name=key,Values=${TAG}" \
    | jq '.Tags[].Value'

