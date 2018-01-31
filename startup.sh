#!/bin/bash
#Version: 2.0.0
#Editor:JarboU
#Date：2017.02.09

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
DATE=$(date +%Y%m%d%H%M)
PIDFILE=/tmp/tomcat.pid
#################配置参数###########################
#中间件位置
SoftPath=/ane/tomcat
#备份目录
BakPath=/ane/bak
#更新目录
UpdatePath=/ane/update
#模块编码
AppName=INF
#JDK目录
JdkPath=/usr/java/jdk1.7.0_67
#进程名称
JDK_NAME=java
#应用包名
WarName=ROOT.war
#jvm监听端口
JxmPort=10001

#################应用参数###########################
HostIP=`ip addr | grep inet.*/24 | awk -F " " '{print $2 }' | awk -F "/" '{print $1}'`
HostMenm=`free -m | grep ^Mem\: |awk -F " " '{print $4}'`
JMenm="`expr $HostMenm \* 75 / 100`m"
JGCMenm="`expr $HostMenm \* 75 / 100 / 8 \* 3`m"
JPermSize="`expr $HostMenm \* 75 / 100 / 8 \* 3 / 4`m"
JAVAOPTS=" -server -Xms$JMenm -Xmx$JMenm -XX:PermSize=$JPermSize -XX:MaxPermSize=$JPermSize -Xmn$JGCMenm -Xss256K   -XX:+CMSClassUnloadingEnabled  -XX:+UseParNewGC  -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0  -XX:+UseFastAccessorMethods -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:ParallelGCThreads=10  -XX:CMSFullGCsBeforeCompaction=0 -XX:+UseCMSCompactAtFullCollection -XX:SurvivorRatio=4  -XX:LargePageSizeInBytes=128m -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+UseCompressedOops -XX:+CMSScavengeBeforeRemark  -XX:MaxTenuringThreshold=15 -XX:TargetSurvivorRatio=90 -XX:+HeapDumpOnOutOfMemoryError -XX:+ShowMessageBoxOnError -Djava.rmi.server.hostname=$HostIP -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$JxmPort -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.awt.headless=true"
#################代码区域###########################
if [ -f $PIDFILE  ] && [ -s $PIDFILE ]
        then
        PID=`cat $PIDFILE`

        if [ "x$PID" != "x" ] && kill -0 $PID 2>/dev/null && [ $JDK_NAME == `ps -e | grep $PID | awk '{print $4}'` ]
        then
                STATUS="tomcat (pid `pidof tomcat`) running.."
                RUNNING=1
        else
                rm -f $PIDFILE
                STATUS="tomcat (pid file existed ($PID) and now removed) not running.."
                RUNNING=0
        fi
else
        if [ `ps -e | grep $JDK_NAME | head -1 | awk '{ print $1 }'` ]
                then
                STATUS="tomcat (pid `pidof $APP`, but no pid file) running.."
        else
                STATUS="tomcat (no pid file) not running"
        fi
        RUNNING=1
fi

			
start() {
        if [ $RUNNING -eq 1 ]
                then
		export JAVA_HOME="$JdkPath"
		echo "JDK版本"
		$JAVA_HOME/bin/java -version
		pid=`ps -ef |grep $SoftPath | grep -v grep | awk '{print $2}'`
		kill -9 $pid
		export JAVA_OPTS="$JAVAOPTS"
		rm -rf $SoftPath/temp/*
		rm -rf $SoftPath/work/*
		rm -rf $SoftPath/webapps/*
		echo "缓存清除完成,项目更新开始"
		cp -r $UpdatePath/$WarName $SoftPath/webapps/$WarName
		echo "项目启动中，请稍后....."
		cd $SoftPath/bin/
		nohup ./startup.sh -Dfile.encoding=utf-8 > /dev/null 2>&1 &
		echo "项目启动完成!"
		#tail -500f $SoftPath/logs/catalina.out
        else
                echo "启动失败请检查配置文件！"
                rm -rf /tmp/tomcat.pid
        fi
}

stop() {
	export JAVA_HOME="$JdkPath"
        #export JAVA_OPTS="$JAVAOPTS"
        $SoftPath/bin/catalina.sh stop
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ]
        RUNNING=1
		echo "tomcat关闭"
	
}
backup() {
	echo "执行备份"
	mkdir $BakPath/$AppName$DATE -p
	chown -R ane.ane $BakPath
	cp -r $SoftPath/webapps/$WarName $BakPath/$AppName$DATE/
	echo "执行备份成功!"


}


case "$1" in
        start)
		backup
                start
                ;;
        stop)
                stop
                ;;
        backup)
                backup
                ;;
        restart)
                stop
		sleep 5
		backup
                start
                ;;												
esac

exit 0	
