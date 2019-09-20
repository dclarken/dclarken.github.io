#远程登录执行相关命令
ssh user@ip "cmd"
#父目录
echo $(dirname $(pwd))
============================================================================================================
#!/bin/bash
cd `dirname $0`
binPath=`pwd`
============================================================================================================
#文本操作
#!/bin/bash
sed -i 's/ /\n/g' ${filename}
#可以添加换行到文本中
sed -i 's/$/&<br>/g' ${filename}
#去除空行
grep -v "^$" ${filename}
sed '/^$/d' ${filename}
#去除空行并保存在filename中
sed -i '/^$/d' ${filename}
#在每行的头添加字符，比如"HEAD"，命令如下：
sed 's/^/HEAD&/g' test.file
#在每行的行尾添加字符，比如“TAIL”，命令如下：
sed 's/$/&TAIL/g' test.file
#sed命令之将换行符转换为空格的方法
sed -i ':a;N;s/\n/ /g;ba' test.file
#第一行加入字符
sed -i "1i\字符串$3" ${filename}
#去除大括号，中括号
sed -i 's/'{'//g'
sed -i 's/\[//g'
#传入变量
sed -i 's/test/'${var}'/g'
#vim模式下批量修改
:进入编辑命令行模式
%s/test/test1/g
#grep 使用perl的正则，匹配指定字符串之间的字符，只需要匹配到的部分
grep -Po
echo "Hello, my name is aming."|grep -Po '(?<=Hello, ).*(?= aming.)'  -> my name is
#awk函数
awk 'BEGIN {print"begin"} {print $1} END {print"END"}'
============================================================================================================
#创建用户，（制作免密）
usergroup=group
username=name 
#创建组
groupadd -g 8888 ${usergroup}
#创建用户并制定home目录并赋予750权限
useradd -G ${usergroup} -d /app/${username}/ ${username}; chmod 750 /app/${username}
useradd -G ${usergroup} ${username}
#修改用户密码
echo 'cnsofhowfjhofjwoefiowefj' |  passwd --stdin ${username}
#制作免密目录
su - ${username}
ssh-keygen -t rsa
#完全删除一个用户的信息
userdel -r username
#添加用户到组
gpasswd -a username ${usergroup}
============================================================================================================
#跳转机器 到其他服务器的免密
cat ~/.ssh/id_rsa.pub_跳转机器ip
复制到需要免密服务器的 ~/.ssh/authorized_keys
============================================================================================================
#制作具有root权限的其他用户
groupadd -g 333 ywadmin
useradd -g ywadmin -d /app/ywadmin/ -u 333 ywadmin
echo 'ywadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer
============================================================================================================
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
============================================================================================================
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
============================================================================================================
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
============================================================================================================
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
============================================================================================================
#比较时间
#!/bin/bash
#时间化作秒来与当前时间作比较
#date -d<字符串>：显示字符串所指的日期与时间。字符串前后必须加上双引号；
dateNow=`date +"%Y-%m-%d"`
timeNow=`date +%s%N`
#当前日期n天以前的日期,n分钟以前的时间
dateNow=`date -d "-n days -n mins" +"%Y-%m-%d %H:%M:%S"`
while read system deadline date name mail
do
	date_start=`date +%s -d "$date"` #date读取到的时间
	date_end=`date +%s -d "$DATE"` #DATE当前时间
	etime=$(($date_end-$date_start))
	ltime=$(($(($deadline))*30*24*3600))
	if [ $etime -gt $time ]; then
      		#sendmail
	fi
done < ${filename}
============================================================================================================
#find查找精确时间生产的文件 查找建立以下指定时间内建立的文件的文件名，| xargs 可以根据实际情况补充
find . -name "RE" -newerct '2018-12-17 02:59:00' ! -newerct '2018-12-17 03:59:00' | xargs | awk -F " " '{print $NF}'
#文件层数n，这个参数一般放在-name前面
-maxdepth n
#查找到某个文件名然后替换其中某个字段，可以用修改配置文件
find /path -name "filename" | xargs | sed -i 's///g'
============================================================================================================
#path路径变量
path="/app/home/local"
out="${path}/out.txt"
============================================================================================================
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
[[ $? -ne 0 ]]&&exit1
#返回0即退出
[[ $? -eg 0 ]]&&exit1
============================================================================================================
function sql()
{
host=
user=
port=
pass=
query=`mysql -N -e -h$host -u$user -p$pass -P$port --default-character-set=utf8<<EOF
use ;
select $1 $2;
exit
EOF`
echo -e "${query}"
}
============================================================================================================
#创建文件
function touchFile()
{
	[[ -f $1 ]] && (cat /dev/null > $1; echo "Script initialization: $1 exit clear it") || (touch $1; echo "Script initialization: $1 not exit touch it")
}
============================================================================================================
#文件没有内容不再继续
function tureFile()
{
	if [ ! -s $1 ];then echo "$1 is empty"; exit 1
	else echo "$1 is true continue"
	fi
}
#创建目录
function touchDir()
{
	[[  -d "$1" ]] && (rm -rf ${1%*/}/;echo "Script initialization: $1 exit clear it" ) || (mkdir -p ${1%*/};echo "Script initialization: $1 not exit mkdir it")
}

function touchDir()
{
	[[  -d "$1" ]] && (echo "Script initialization: $1 exit" ) || (mkdir -p ${1%*/};echo "Script initialization: $1 not exit mkdir it")
}
============================================================================================================
function varChk()
{
	if [[ -z $1 ]]; then echo "var1 null";exit 1
	elif [[ -z $2 ]]; then echo "var2 null";exit 1
	elif [[ -z $3 ]]; then echo "var3 null";exit 1
	else echo "varChk ok"
	fi
}
function varChk()
{
        num=`echo $1| sed  s/number=//g`
        echo "Number of variables: $1"
        let num++
        if [[ $num -eq $# ]];then 
                echo "varChk success, the number of variables is sufficient";
        else
                echo "varChk failed, The number of variables is not enough";
                exit 1
        fi
}
============================================================================================================
#定义输出函数 
#${OutFile}定义为输出文件 $@ 将输入的参数全部传入 <b style="color:red">表示加粗并且显示红色
#格式：tee -a file 输出到标准输出的同时，追加到文件file中。如果文件不存在，则创建；如果已经存在，就在末尾追加内容，而不是覆盖
date +"%Y%m%d%H%M%S"
outDir="${binPath}/log"
#!/bin/bash
cd `dirname $0`
binPath=`pwd`
outFile="${binPath}/.out.log"
function logOut()
{
	echo -e "$@" | tee -a "${outFile}"
}
function logOutWithTime()
{
	echo -e "$(date '+%Y-%m-%d %H:%M:%S.888')|$@" | tee -a "${outFile}"
}
function logOutToFile()
{
	echo -e "$@" | tee -a "$1"
}
function logOut()
{
        if [[ -z $2 ]];then echo -e "$@" | tee -a "${outFile}"
        elif [[ -z $3 ]];then echo -e "$@" | tee -a "$2"
        elif [[ $3 == 'withTime' ]];then echo -e "$(date '+%Y-%m-%d %H:%M:%S.888')|$@" | tee -a "$2"
        fi
}
logOut "<br>""<b style="color:red">输出结果如下</b>""<br>"
logOut "<br>""`cat $out`""<br>"
logOut "\n"
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
============================================================================================================
