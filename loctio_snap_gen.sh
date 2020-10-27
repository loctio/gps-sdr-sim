SNAPSHOT_SAMPLE_PATH=/var/tmp/sample.bin
LOCTIO_API_HOST=192.168.11.46
#LOCTIO_API_HOST=loctio-api.ddns.net
LAT="38.270181"
LON="21.7638"
ALT="60.0"
GROUND_TRUTH="$LAT,$LON,$ALT"
while true;
do
	date
	if [ ! -f $SNAPSHOT_SAMPLE_PATH ];
	then
		#NOW=$(date -u '+%Y%m%d %H:%M:%S' -d '- 10 minutes')
		NOW=$(date -u '+%Y%m%d %H:%M:%S')
		#echo $NOW
		
		DATE=$(date -u +'%Y/%m/%d,%H:%M:%S' -d "$NOW")
		#echo $DATE
		
		REF_TIME=$(date -u +'%Y%m%d%H%M%S' -d "$NOW")
		#echo $REF_TIME
		
		#echo $LOCTIO_API_HOST
		URL="http://$LOCTIO_API_HOST:50505/api/rinex?provider=nasa&ref_pos0=$LAT&ref_pos1=$LON&ref_pos2=$ALT&ref_time=$REF_TIME&raw=1"
		curl -X GET $URL > rinex.txt				
		head -1 rinex.txt
		GPS_SDR_SIM_CMD="./gps-sdr-sim -s 2800000 -b 1 -d 1 -e rinex.txt -t $DATE -T $DATE -l $GROUND_TRUTH -o $SNAPSHOT_SAMPLE_PATH"
		$($GPS_SDR_SIM_CMD)
	else
		ls -al $SNAPSHOT_SAMPLE_PATH
	fi
	sleep 1;
done