#远程登录执行相关命令
ssh user@ip "cmd"
#父目录
echo $(dirname $(pwd))
#============================================================================================================
#!/bin/bash
cd `dirname $0`
binPath=`pwd`
#============================================================================================================
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
#假设 s 是含回车的字符串，将换行转化为tab
echo $s|tr '\n' '\t'
#log日志查找，查找目录下的所有文件，color参数添加颜色标记
grep -ir --color findChar *normal* .
#============================================================================================================
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
#============================================================================================================
#跳转机器 到其他服务器的免密
cat ~/.ssh/id_rsa.pub_跳转机器ip
复制到需要免密服务器的 ~/.ssh/authorized_keys
#============================================================================================================
#制作具有root权限的其他用户
groupadd -g 333 ywadmin
useradd -g ywadmin -d /app/ywadmin/ -u 333 ywadmin
echo 'ywadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer
#============================================================================================================
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
#============================================================================================================
#find查找精确时间生产的文件 查找建立以下指定时间内建立的文件的文件名，| xargs 可以根据实际情况补充
find . -name "RE" -newerct '2018-12-17 02:59:00' ! -newerct '2018-12-17 03:59:00' | xargs | awk -F " " '{print $NF}'
#文件层数n，这个参数一般放在-name前面
-maxdepth n
#查找到某个文件名然后替换其中某个字段，可以用修改配置文件
find /path -name "filename" | xargs | sed -i 's///g'
#查找一个月前的日志并删除
find /path -mtime +30 -type f -name \*.zip -exec rm -f {} \;
#============================================================================================================
#path路径变量
path="/app/home/local"
out="${path}/out.txt"
#============================================================================================================
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
#============================================================================================================
dirA=/app/image/upload/fermsupload/st1/
dirB=/app/esi/cmp-ferms-resource/image/

磁盘目录共享设置 把A上的目录dirA挂载到B上的dirB
A:
/etc/init.d/rpcbind start
/etc/init.d/nfs start 

vim /etc/exports
#dirA *(rw,sync,no_root_squash)
dirA *(rw,no_root_squash)
service nfs restart

vim /etc/rc.d/rc.local
service nfs restart
exportfs –rv
service iptables stop

bash /etc/rc.d/rc.local

B:
/etc/init.d/rpcbind start
/etc/init.d/nfs start 

vim /etc/rc.d/rc.local
mount -t nfs -o rw A:dirA  dirB
bash /etc/rc.d/rc.local

vim /etc/idmapd.conf ##把nobody调整为esi


取消挂载：
B:
/etc/init.d/rpcbind stop 
/etc/init.d/nfs stop 
umount dirB  


技术二：
dirA=/app/image/upload/fermsupload/st1/
dirB=/app/esi/cmp-ferms-resource/image/

磁盘目录共享设置 把A上的目录dirA挂载到B上的dirB
A：
。。。

B：
yum install nfs-utils
vim /etc/fstab
    A:dirA dirB nfs nfsvers=3,hard,timeo=600,retrans=2,_netdev 0 0 
mount -t nfs -o vers=3,nolock,proto=tcp A:dirA dirB 
gpasswd -a ${userName} nfsnobody 


取消挂载：
umount dirB 
yum erase nfs-utils
#============================================================================================================
进程放在后台跑的方法
1、ctrl+z 先放到后台 
[1]+  Stopped                 ./test.sh
2、bg %1   放入到后台添加&
3、disown -h %1  使后台进程1忽略HUP信号
4、现在执行logout或者直接关闭ssh客户端进程也会在后台继续执行了
5、使用screen,进入后按Ctrl+A  D退出
6、一个终端使用screen -S hello,另外一个使用 screen -x hello 可以看到相同屏幕，并同时可以操作
#===========================================================================================
#curl http返回码
curl -l -m 10 -o /dev/null -s -w %{http_code} https://www.baidu.com
#squid代理验证,代理端口为accept=127.0.0.1:3888  验证：
curl -x "127.0.0.1:3888" -l -m 10 -o /dev/null -s -w %{http_code} https://cvm.tencentcloudapi.com
#https url验证
wget --no-check-certificate 
curl -k
#===========================================================================================================================
#异常分析
#TCP连接状态分析https://blog.csdn.net/m0_37556444/article/details/83000553
netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn 
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
#网络路由分析工具
mtr -i 0.1 -n -c 100 IP或域名
mtr --report -c 100 -n IP
#指定间隔保存抓包
tcpdump -i eth0 host xxxx -s0 -G 600  -w %Y_%m%d_%H%M_%S.pcap
tcpdump host XXXX -w /tmp/%Y_%m%d_%H%M_%S.pcap 
#curl
curl -L --output /dev/null --silent --show-error --write-out 'lookup: %{time_namelookup}\nconnect:%{time_connect}\nappconnect:%{time_appconnect}\npretransfer:%{time_pretransfer}\nredirect:%{time_redirect}\nstarttransfer: %{time_starttransfer}\ntotal:%{time_total}\n' '58.0.61.4'
#===========================================================================================
#做进程内存分析：	
jstat -gcutil pid 2000 10 #每2秒打印一条GC信息
1)jmap -dump:live,format=b,file=xxx.xxx PID 
2)jmap -histo:live PID > xxx.xxx 
	 
jstat -gccapacity pid
jstat -class pid
jstat -printcompilation pid

top -Hp ${PID}
stack ${PID} |grep ${TID} -A 30 
jstat -gcunit ${PID} 1000 
	
top -Hp ${PID}  #得到异常的TID
x 选中 b光标 shift+>左右移动光标
jstack ${TID}  #搜索异常TID的16进制
