# TODO

get-tag

   - Run on an EC2 instance using the default aws profile (which should be setup with readonly creds)
   - Implement command line option to specify alternate profile to use
   - Pull down the "Name" tag by default
   - Pull down a specific tag if specified on the command line in $1
   - If multiple args are provided, each one is a tag Key, so return all values in various formats:
      - default format: key=value pairs, one on each line
      - JSON
      - YAML
      - .csv
   - Results will be cached in /var/somewhere
   - Subsequent calls to get-tag will use the cached results for speed
      - Possibly implement --from-cache or --from-api flags to give more control over if the caller wants results from the cache or from the aws api call (slower)
   - Using a --refresh command line arg will refresh the cached data (in case it has changed)

get-all-tags

   - Pull down all tags for the current instance in all formats supported by get-tag
   - As a side-effect of calling get-all-tags, all of the current tag data will be cached


