#!/bin/bash
#Version: 2.0.0
#Editor:JarboU
#Date：2017.02.09

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
DATE=$(date +%Y)
#################配置参数###########################
AppLogPath=/ane/tomcat/logs
BakPath=/ane/bak
#################代码区域###########################
Log_Flies01=`echo $AppLogPath | xargs ls -alh  | tail -n +4 | awk -F" " '{print $9}' | awk -F"-" '{print $1}'`
File_Percentage=`df -h / | awk -F " " '{print $5}'| awk -F "%" '{print $1}'| tail -n +2`
echo $File_Percentage
if [ $File_Percentage -ge  75 ];then
       for line in $Log_Flies01
        do
                Tuple=$line-*
                find $AppLogPath  -mtime +7 -type f -name $Tuple -exec rm -rf {} \;				
		find $AppLogPath  -type f -size +2G -name $Tuple -exec rm -rf  {} \;	
                echo " " > $AppLogPath/catalina.out
         done
		find $BakPath/ -mtime +7 -type d -name ".*$DATE*" -exec rm -rf {} \;
fi
