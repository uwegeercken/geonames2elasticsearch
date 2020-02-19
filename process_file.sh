#!/bin/bash
#
# script removes double quotes from the input file and creates two
# lookup files for the admin3 and admin4 codes.
# finally runs a logstash pipeline to transform the input CSV rows
# to send them to elasticsearch.
#
# uwe geercken - last update: 2018-10-15
#

root_folder="/home/uwe/development/geonames"
lookup_folder="${root_folder}/lookup"
logstash_folder="/opt/logstash"
logstash_config="${root_folder}/geonames_1.yml"

elasticsearch_host="http://localhost:9200"

input_file="$(readlink -f ${1})"

echo
echo "$(date '+%Y-%m-%d %H:%M:%S') load geonames data to eleasticsearch"

echo "$(date '+%Y-%m-%d %H:%M:%S') removing double quotes in input file"
sed -i 's/"//g' "${input_file}"

echo "$(date '+%Y-%m-%d %H:%M:%S') creating lookup file for admin code 3"
awk 'BEGIN{FS="\t"} $13 && $7=="A" && $8=="ADM3" {print $9 "." $11 "." $12 "." $13 "," $2}' "${input_file}" > "${lookup_folder}/admincodes3_lookup.csv"

echo "$(date '+%Y-%m-%d %H:%M:%S') creating lookup file for admin code 4"
awk 'BEGIN{FS="\t"} $14 && $7=="A" && $8=="ADM4" {print $9 "." $11 "." $12 "." $13 "." $14 "," $2}' "${input_file}" > "${lookup_folder}/admincodes4_lookup.csv"

# env variables for logstash
export LOGSTASH_PIPELINE_ELASTICSEARCH_HOST="${elasticsearch_host}"
export LOGSTASH_PIPELINE_ROOT_FOLDER="${root_folder}"
export LOGSTASH_PIPELINE_LOOKUP_FOLDER="${lookup_folder}"
export LOGSTASH_PIPELINE_INPUT_FILE="${input_file}"

echo "$(date '+%Y-%m-%d %H:%M:%S') running logstash file: ${logstash_config}"
echo "$(date '+%Y-%m-%d %H:%M:%S') using input file file: ${input_file}"
. $("${logstash_folder}"/bin/logstash -b 1000 -w 4 -f "${logstash_config}")

echo "$(date '+%Y-%m-%d %H:%M:%S') end of process"
