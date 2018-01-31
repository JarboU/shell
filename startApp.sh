#!/bin/bash
#Version: 2.0.0
#Editor:JarboU
#Date：2017.02.09

DATE=$(date +%Y%m%d%H%M)
pkill -9 -f tomcat1
sleep 10
echo "tomcat关闭"
SoftPath=/ane/tomcat1
#中间件位置
BakPath=/ane/bak/
#备份目录
UpdatePath=/ane/update
#更新目录
AppName=BS
#模块应用名字
JdkPath=/usr/java/jdk1.7.0_67
#jdk目录

export JAVA_HOME="$JdkPath"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Tomcat与JDK版本："
cd $SoftPath/bin
./version.sh
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
export JAVA_OPTS="-server -Xms2048m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=512m -Xmn512m -Xss256K   -XX:+CMSClassUnloadingEnabled  -XX:+UseParNewGC  -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0  -XX:+UseFastAccessorMethods -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:ParallelGCThreads=10  -XX:CMSFullGCsBeforeCompaction=0 -XX:+UseCMSCompactAtFullCollection -XX:SurvivorRatio=1  -XX:LargePageSizeInBytes=128m -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCompressedOops -XX:+CMSScavengeBeforeRemark  -XX:MaxTenuringThreshold=15 -XX:TargetSurvivorRatio=90 -XX:+HeapDumpOnOutOfMemoryError -XX:+ShowMessageBoxOnError 
-Djava.rmi.server.hostname=10.113.128.28
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=10001
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
-Dsun.rmi.dgc.client.gcInterval=3600000
-Dsun.rmi.dgc.server.gcInterval=3600000
-Dsun.lang.ClassLoader.allowArraySyntax=true
-Djava.awt.headless=true
"
echo "执行备份"
mkdir $BakPath/$AppName$DATE -p
cp -r $SoftPath/webapps/ROOT.war $BakPath/$AppName$DATE -p
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#echo "代码文件对比:"
#find $SoftPath/webapps/ROOT -type f | xargs md5sum   > $BakPath/$DATE/tomcat.diff 2> /dev/null
#find $UpdatePath/ROOT -type f | xargs md5sum  > $BakPath/$DATE/update.diff 2> /dev/null
#sed -i 's/\/ane\/update\//\/ane\/tomcat\/webapps\//g' $BakPath/$DATE/update.diff
#diff $BakPath/$DATE/tomcat.diff $BakPath/$DATE/update.diff > $BakPath/$DATE/diff.txt
#Diff=`cat $BakPath/$DATE/diff.txt | wc -l`
#echo $Diff
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "执行备份成功,开始清理缓存"
rm -rf $SoftPath/temp/*
rm -rf $SoftPath/work/*
rm -rf $SoftPath/webapps/*
echo "缓存清除完成,项目更新开始"
cp -r $UpdatePath/ROOT.war $SoftPath/webapps/
echo "项目启动中，请稍后....."
cd $SoftPath/bin/
nohup ./startup.sh -Dfile.encoding=utf-8 > /dev/null 2>&1 &
echo "项目启动完成!"
