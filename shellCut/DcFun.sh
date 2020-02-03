#!/bin/bash
dateNow=`date +"%Y-%m-%d"`
timeNow=`date +%s%N`
binPath=`pwd`
host=`hostname -I|sed 's/ //g'`
outFile="/tmp/${timeNow}.out.log"
outDir="${binPath}/logs"
#outFile="${binPath}/${timeNow}.out.log"
#创建文件
function touchFile()
{
	[[ -f $1 ]] && (cat /dev/null > $1; echo "Script initialization: $1 exit clear it") || (touch $1; echo "Script initialization: $1 not exit touch it")
}
#touchFile ${outFile}
#创建目录
function touchDir()
{
	[[  -d "$1" ]] && (echo "Script initialization: $1 exit" ) || (mkdir -p ${1%*/};echo "Script initialization: $1 not exit mkdir it")
}
#touchDir ${outDir}
#默认赋值
function assignment()
{
	if [[ ! -z $1 ]];then
		a=$1
	else
		a=unassignment
	fi
echo $a 
}
#a=`assignment $1`
#日志输出
function logOut()
{
        if [[ -z $2 ]];then echo -e "$(date '+%Y-%m-%d %H:%M:%S.888')|${host}|$@" | tee -a "${outFile}"
        elif [[ -z $3 ]];then echo -e "$1" | tee -a "$2"
        elif [[ $3 == 'withTime' ]];then echo -e "$(date '+%Y-%m-%d %H:%M:%S.888')|${host}|$1" | tee -a "$2"
        fi
}
#logOut "123"
#logOut "123" ${outFile}
#logOut "123" ${outFile} withTime
#变量数量核查
function varChk()
{
        num=`echo $1| sed  s/number=//g`
        echo "Number of variables: $1"
        let num++
        if [[ $num -eq $# ]];then 
                echo "varChk success, the number of variables is sufficient"
        else
                echo "varChk failed, The number of variables is not enough"
                exit 1
        fi
}
# varChk number=3 var1 var2 var3
#telnet验证
function telnetChk()
{
        ip=$1
        port=$2
        result=`sleep 1|timeout 5 telnet $ip $port`
        flag=`echo -e "${result}" | grep 'Escape character is'|sed 's/is.*$/is/g'`
        if [ "$flag" != "Escape character is" ]; then
                echo "telnet $ip $port failed" 
				return 1
        else
                echo "telnet $ip $port success"
                return 0
        fi
}
#并发锁
lockFile="${binPath}/lockFile"
shellLock()
{
	touch ${lockFile}
}
shellUnlock()
{
	rm -f ${lockFile}
}
if [ -f ${lockFile} ];then
	echo "$0 is runing, please wait" && exit
fi
#kill前后都保留现场, 两次ps -ef|grep -w 关键字|grep -v grep >>/tmp/kill_进程名_.backup；
function pidChk()
{
	if [ $pid -gt 1-a $pid -lt 9999999999999 ];
	then 
		kill
	else
		retturn_str="$pid"
	fi
}

#定义输出函数带颜色参数
function logOutC()
{
	case $2 in
        green)
	    echo -e "\033[32;40m$1\033[0m" | tee -a "${outFile}"
            ;;	
        red)
            echo -e "\033[31;40m$1\033[0m" | tee -a "${outFile}"
            ;;
        *)
            echo -e "$@" | tee -a "${outFile}"
    esac			
}
function logOutC()
{
	if [[ $2 == "green" ]]; then echo -e "\033[32;40m$1\033[0m" | tee -a "${outFile}"
	elif [[ $2 == "red" ]]; then echo -e "\033[31;40m$1\033[0m" | tee -a "${outFile}"
	else echo -e "$@" | tee -a "${outFile}"
	fi 
}
使用方法：echo_color "test" green
