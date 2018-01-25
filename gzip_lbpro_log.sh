log_path="/data/logs/lblogs/lbprologs"
last_day_y=`date -d "-1 day" +%Y`
last_day_m=`date -d "-1 day" +%m`
last_day_d=`date -d "-1 day" +%d`
file_path=$log_path'/'$last_day_y'/'$last_day_m'/'$last_day_d

echo $file_path
gzip -r $file_path
cd $file_path

for var in *.gz; do mv "$var" "${var%.gz}_$last_day_y$last_day_m$last_day_d.gz"; done
