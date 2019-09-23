'''
转换进制十进制转化为任意进制n
'''
def change(n,num):
    list1 = []
    if num==1:
        return 1
    while num > 1 :
        list1.append(str(num % n))
        num /= n
        list1.append(str(num))
        list1.reverse()
    list1=int(''.join(list1))
    return list1
'''
计算一个n进制数字各个位数的和
'''
def sum_wei(n,num):
    count=0
    while num >= 1 :
        count +=num%n
        num /= n
    return count
'''
判断是否为素数
'''
def is_prime(n):
    for i in range(2, int(math.sqrt(n)) + 1):
        if n%i == 0:
            return False
    return True
'''
判断是否为回文数
'''
def is_hui(n):  
    n=str(n)  
    m=n[::-1]  
    if n==m:
        return True 
    else:
        return False 
  '''
  字符串循环左移
  '''
def LeftRotateString(s, n):
    return (s[n:]+s[:n])
  '''
  以空格为拆分倒输出一个字符串
  '''
def ReserveSentence(x):
    x=x.split(' ')
    x=x[::-1]
    x=' '.join(x)
    return (x)
'''
将一个字符串中的空格替换成“%20”。
例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy
'''
def replaceSpace(self, s):
    s = list(s)
    count=len(s)
    for i in range(0,count):
        if s[i]==' ':
            s[i]='%20'
    return ''.join(s)
'''
一个整型数组里除了两个数字之外，其他的数字都出现了两次。请写程序找出这两个只出现一次的数字。
'''
def FindNumsAppearOnce(array):
    tmp=[]
    for i in array:
        if i in tmp:
            tmp.remove(i)
        else:
            tmp.append(i)
    return (tmp)
'''
求出1~13的整数中1出现的次数,并算出100~1300的整数中1出现的次数？
为此他特别数了一下1~13中包含1的数字有1、10、11、12、13因此共出现6次,但是对于后面问题他就没辙了。
ACMer希望你们帮帮他,并把问题更加普遍化,可以很快的求出任意非负整数区间中1出现的次数。
'''
def NumberOf1Between1AndN_Solution(n):
    res=0
    tmp=n
    base=1
    while tmp:
        last=tmp%10
        tmp=tmp/10
        res+=tmp*base
        if last==1:
            res+=n%base+1
        elif last>1:
            res+=base
        base*=10
    return res

'''
python中argparse模块
使用argparse模块获取脚本参数
'''
#首先导入模块
import argparse    
#创建一个解析对象
parser = argparse.ArgumentParser(description='-p "{dict}"')
#向该对象中添加你要关注的命令行参数和选项
parser.add_argument('-p','--param',help='脚本参数')
#进行解析  
args = parser.parse_args()
#从param串中获取参数
param = args.param
#eval函数实现list、dict、tuple与str之间的转化;str函数把list，dict，tuple转为为字符串
param_dict = eval(param)
