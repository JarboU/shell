#/bin/bash
ROOT=/ane/tomcat/webapps
Tomcat=/ane/tomcat
pkill -9 -f tomcat
AppName=BB
export JAVA_HOME="/usr/java/jdk1.7.0_67/"
export JAVA_OPTS=" -Xms2048m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=256m -Xmn256m -Xss256K   -XX:+CMSClassUnloadingEnabled  -XX:+UseParNewGC  -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0  -XX:+UseFastAccessorMethods -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:ParallelGCThreads=10  -XX:CMSFullGCsBeforeCompaction=0 -XX:+UseCMSCompactAtFullCollection -XX:SurvivorRatio=1  -XX:LargePageSizeInBytes=128m -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCompressedOops -XX:+CMSScavengeBeforeRemark  -XX:MaxTenuringThreshold=15 -XX:TargetSurvivorRatio=90 -XX:+HeapDumpOnOutOfMemoryError -XX:+ShowMessageBoxOnError -Djava.awt.headless=true
-Djava.rmi.server.hostname=10.113.128.34   
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=10001
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
-Dsun.rmi.dgc.client.gcInterval=3600000
-Dsun.rmi.dgc.server.gcInterval=3600000
-Dsun.lang.ClassLoader.allowArraySyntax=true"
DATE=$(date +%Y%m%d%H%M)
mkdir -p /ane/bak/$AppName$DATE
cp -r $ROOT/ROOT.war /ane/bak/$AppName$DATE/
echo "tomcat关闭"
echo "缓存清除"
rm -rf $Tomcat/temp/*
rm -rf $Tomcat/work/*
rm -rf $Tomcat/webapps/*
echo "项目更新"
cp -r /ane/update/ROOT.war $ROOT/
echo "项目启动，请稍后"
cd $Tomcat/bin/
nohup ./startup.sh -Dfile.encoding=utf-8 > /dev/null 2>&1 &
echo 'ok'
