# docker-check-disk-usage

A Docker container to check the disk usage on the parent machine and report the results back to Slack.

Did you know that sometimes Docker can fill up all available space the host machine's disk?

Yep, I had it happen just like night, and it caused a multi-hour outage for some sites that I manage. 
The disk usage looked like this:

<img src="https://raw.githubusercontent.com/dmuth/docker-check-disk-usage/master/img/docker-disk-full.jpg" />

So that fun, yep.

## Usage

- `cp docker-compose.yml.example docker-compose.yml` # Make a copy of our docker-compose file
- `vim docker-compose.yml` # Fill in the percentage threshold and Slack webhook for your instance
- `docker-compose up -d` # Start the container!

By default, this container will check the disk usage once per hour and send you an alert if the 
status changes to "danger" or back to "good".  An alert will be sent at most once per state change.






