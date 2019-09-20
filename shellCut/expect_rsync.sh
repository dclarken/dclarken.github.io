##自动填写密码进行同步
acount=user@ip
passwd=Passwd
destPath=
destPathTemp=
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
##同步远程服务器至临时目标目录
可执行命令rsync_expect
rsync_expect ${account}:${destPath} ${destPathTemp%/*}
