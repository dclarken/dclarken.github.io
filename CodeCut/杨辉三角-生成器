```
杨辉三角

杨辉其特性在于：可以通过将前一行的样辉三角的输出作为下一行的输入，从而得到新的一行。
利用生成器实现每次循环后的L表示为杨辉三角某一行的输出结果，且满足行数对应为L的长度。
yield的特性在于循环每次遇到yield都会停止执行，然后等待一下调用函数，继续成上一次程序
停止的地方开始继续执行程序。所有对于有yield的生成器输出一般需要利用for循环。
```
#coding:utf-8

def triangles(num):
    L = [1]
    for n in range(num):
        yield L
        L = [1]+[L[i]+L[i+1] for i in range(n)]+[1]
        
for t in tri(5):
    print(t)
    
---

```
对比没有用生成器的代码:
```
def triangles(max):
    L = [1]
    i = 1
    n = 0
    while i < max:
        print(L)
        L = [1]+[L[i] + L[i+1] for i in range(len(L)-1)]+[1]
        i += 1
        n += 1

triangles(5)
