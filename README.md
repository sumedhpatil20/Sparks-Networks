# Open ubuntu terminal
## Run following commands:

mkdir -p /root/sumedh-demo

cd /root/sumedh-demo

git clone https://github.com/sumedhpatil20/Sparks-Networks.git

cd Sparks-Networks

python3 -m pip install requirement.txt

Login to Snowflake Account through chrome. 

Use URL http://app.snowflake.com/ap-northeast-1.aws/ye45168/

Execute all DDL ( create ) commands specified in file sql_DDL_DML_Scripts.sql to create tables in RAW_DB and PRODUCTION_DB.

### open ingest.py file with text editor to edit Snowflake Connection Parameters like USER_NAME, PASSWORD and ACCOUNT URL from requirements file 
vim ingest.py
### Save file.

### List all crontabs
crontab -l

### Edit crontab
crontab -e 
### Below command run ingest.py file on first minute of every day 
paste "00 00 * * * python3 <file_location>/ingest.py " without quotes at end of file.

### Run below command to start cron servive for daily run
sudo service cron start

Execute all DML ( insert ) commands specified in file sql_DDL_DML_Scripts.sql to populate PRODUCTION_DB tables in Snowflake.
