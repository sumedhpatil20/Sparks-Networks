### Download ingest.py file.
### install all python dependencies listed in requirements file.
### Edit Snowflake Connection Parameters like USER_NAME, PASSWORD and ACCOUNT URL from requirements file 
### Save [ctrl + s] file.

# Open ubuntu terminal
## Run following commands:
### List all crontabs
crontab -l

### Edit crontab
crontab -e 
### Below command run ingest.py file on first minute of every day 
paste "00 00 * * * python3 <file_location>/ingest.py " without quotes at end of file.

### Run below command to start cron servive for daily run
sudo service cron start
