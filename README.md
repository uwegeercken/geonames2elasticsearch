# geonames2elasticsearch
Using a shell script to steer the process to read and transform geolocation data from https://geonames.com using logstash and sending it to Elasticsearch

- the shell scripts sets all required variables
- sed is used to remove all double quotes from the input file
- awk is used to create lookup files for the admin 3rd and admin 4th level from the input file
- logstash is started. it translates the data and does the lookups/matching
- the data is sent to the Elasticsearch host

The lookup folder contains files that are used by Logstash to lookup/match terms. These files are either from the https://geonames.org website (http://download.geonames.org/export/dump/) or have been derived directly from the data. The purpose is to have a format of the lookup files that is required by Logstash.

To run the process:
- install Logstash, ELasticsearch and Kibana from the https://www.elastic.co website. That is very easy!
- Run Elasticsearch and Kibana
- download the allCountries.zip file from https://geonames.com and unzip it
- adjust the variable "root_folder", "logstash_folder" and "elasticsearch_host" as appropriate for your system in the process_file.sh script
- run the Linux shell script process_file.sh and pass the path and filename of the unzipped geonames file (allCountries.txt). e.g. ./process_file.sh /home/myuser/geonames/allCountries.txt

The geo location data contains over 11 million points and has a size of around 2.8 Gb on disk. Depending on your system, the process will run a bit until all data has been imported.

The geonameid - a unique id for each data point - is used as the id in Elasticsearch. This means that when you download a new file from geonames.org, you can re-run the process to get an up-to-date data set; existing data point are updated (based on the geonameid) and new ones are inserted. But this does not include deleted points - I will implement this later maybe.

Hope you enjoy it and thanks for any feedback.

Copyright Uwe Geercken, 2018-2020
last update 2020-02-19

