#!/bin/bash
############
#功能说明
#
#参数说明
#参数1
#参数2
#参数3
#20191121 dc v1.0
#
############
set -eu
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
#返回非0即退出
function exitLog()
{
	if [[ $? -ne 0 ]];then 
		echo "$@"
		exit 1
	fi
}
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
function telnetChk()
{
		result="/tmp/${timeNow}.result.log"
		touchFile ${result}
        ip=$1
        port=$2
#        result=`sleep 1|timeout 5 telnet $ip $port`
#        flag=`echo -e "${result}" | grep 'Escape character is'|sed 's/is.*$/is/g'`
  	timeout 5 telnet $ip $port<<EOF 2>${result} 1>&2
quit
EOF
	flag=`cat "${result}" | grep 'Escape character is'|sed 's/is.*$/is/g'`
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
#============================================================================================================
#判断字符是否为空 文件是否有内容
STRING=
filename=
if [ -s "$filename" ]; then 
    echo "filename is not empty" 
fi
[[ ! -s "$filename" ]] && (echo "$filename is empty";exit 1)
#
if [ -z "$STRING" ]; then 
    echo "STRING is empty" 
fi
#-n该方法只能判断是否存在，不能判断是否为空值
if [ -n "$STRING" ]; then 
    echo "STRING is not empty" 
fi
#返回非0即退出
[[ $? -ne 0 ]]&&exit 1
#返回0即退出
[[ $? -eg 0 ]]&&exit 1
#============================================================================================================
#远程同登陆 有的时候直接远程同步会失败，在前面加一层远程登陆又好了
#!/bin/bash
##自动填写密码进行同步
acount=user@ip
passwd=Passwd
destPath=
destPathTemp=
#acount=$1 destPath=$2 
ssh_expect(){
	/usr/bin/expect <<-EOF
	set time 30
	spawn ssh $1
	expect {
		"*yes/no" { send "yes\r"; exp_continue }
		"*password:" { send "${passwd}\r" }
	}
	expect "*@*"
	EOF
}
ssh_expect ${acount}@${ip}
#============================================================================================================
#远程同步
#!/bin/bash
##自动填写密码进行同步
acount=user@ip
passwd=Passwd
destPath=
destPathTemp=
#acount=$1 destPath=$2 
rsync_expect(){
	/usr/bin/expect <<-EOF
	set time 30
	spawn rsync -avH $1 $2
	expect {
		"*yes/no" { send "yes\r"; exp_continue }
		"*password:" { send "${passwd}\r" }
	}
	expect "*@*"
	EOF
}
##同步远程服务器至临时目标目录,可执行命令rsync_expect
rsync_expect ${acount}:${destPath} ${destPathTemp%/*}
#============================================================================================================
#远程自动创建目录
acount=name@ip
passwd=Passwd
destPath=
mkdir_expect(){
	/usr/bin/expect <<-EOF
	set time 30
	
	spawn ssh $1
	expect {
		"*yes/no" { send "yes\r"; exp_continue }
		"*password:" { send "${passwd}\r" }
	}
	expect "*@*"
	send "mkdir -p $2\r"
	
	expect "*@*"
	send "\r"
	expect "*@*"
	EOF
}
mkdir_expect ${acount} ${destPath%/*}
#============================================================================================================
#远程调整权限
acount=name@ip
passwd=123456
destPath=
permission=name:name:644
Ops=rsyOps
chown_expect(){
	/usr/bin/expect <<-EOF
	set time 30
	
	spawn ssh $1
	expect {
		"*yes/no" { send "yes\r"; exp_continue }
		"*password:" { send "${passwd}\r" }
	}
	expect "*@*"
	send "chown -R ${3%:*} $2\r"
	expect "*@*"
	send "chmod -R ${3##*:} $2\r"
	
	expect "*@*"
	send "\r"
	expect "*@*"
	EOF
}
chown_expect ${acount} ${destPath} ${permission}
