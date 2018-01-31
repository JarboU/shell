#!/bin/bash
#Version: 2.0.0
#Editor:JarboU
#Date：2017.02.09

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Path1=/ane/tomcat1/logs/
Path2=/ane/tomcat2/logs/
Path3=/ane/bak/

#echo " " > /ane/tomcat/logs/catalina.out
find $Path1  -mtime +7 -name 'catalina.*' -exec rm -rf {} \;
find $Path1  -mtime +7 -name 'host-manager.*' -exec rm -rf {} \;
find $Path1  -mtime +7 -name 'localhost.*' -exec rm -rf {} \;
find $Path1  -mtime +7 -name 'localhost_access_log.*' -exec rm -rf {} \;
find $Path1  -mtime +7 -name 'manager.*' -exec rm -rf {} \;
find $Path2  -mtime +7 -name 'catalina.*' -exec rm -rf {} \;
find $Path2  -mtime +7 -name 'host-manager.*' -exec rm -rf {} \;
find $Path2  -mtime +7 -name 'localhost.*' -exec rm -rf {} \;
find $Path2  -mtime +7 -name 'localhost_access_log.*' -exec rm -rf {} \;
find $Path2  -mtime +7 -name 'manager.*' -exec rm -rf {} \;
find $Path3  -mtime +7 -name '0BS*' -exec rm -rf {} \;
