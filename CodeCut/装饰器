第六步：对参数数量不确定的函数进行装饰

# -*- coding:utf-8 -*-
'''参数用(*args, **kwargs)，自动适应变参和命名参数'''
def deco(func):
    def _deco(*args, **kwargs):
        print ("before %s called." % func.__name__)
        ret = func(*args, **kwargs)
        print (" after %s called. result: %s" % (func.__name__, ret))
        return ret
    return _deco
    
@deco
def myfunc1(a, b):
    print (" myfunc(%s,%s) called." % (a, b))
    return a+b
    
@deco
def myfunc2(a, b, c):
    print (" myfunc2(%s,%s,%s) called." % (a, b, c))
    return a+b+c
    
myfunc1(1, 2)
myfunc1(3, 4)
myfunc2(1, 2, 3)
myfunc2(3, 4, 5)

#结果
before myfunc1 called.
 myfunc(1,2) called.
 after myfunc1 called. result: 3
before myfunc1 called.
 myfunc(3,4) called.
 after myfunc1 called. result: 7
before myfunc2 called.
 myfunc2(1,2,3) called.
 after myfunc2 called. result: 6
before myfunc2 called.
 myfunc2(3,4,5) called.
 after myfunc2 called. result: 12

第七步：装饰器带可变参数

# -*- coding:utf-8 -*-
'''在装饰器第四步4的基础上，让装饰器带参数，和上一示例相比在外层多了一层包装。装饰函数名实际上应更有意义些'''
def deco(arg): 
    def _deco(func):
        def __deco():
            print ("before %s called [%s]." % (func.__name__, arg))
            func()
            print ("after %s called [%s]." % (func.__name__, arg))
        return __deco
    return _deco
        
@deco("mymodule1")  #装饰器参数是一个字符串，本身没有含义
def myfunc():
 print (" myfunc() called.")

@deco("mymodule2")
def myfunc2():
 print (" myfunc2() called.")

myfunc()  #调用过程等价于：deco("mymodule1")()()-->_deco()()-->__deco()  
myfunc2()

#解析三组闭包：
1. deco("mymodule1")()()+arg-->返回_deco函数对象
2. _deco()()+arg+func -->返回__deco函数对象
3. __deco()+arg+func  --返回函数最终执行结果

执行结果：
before myfunc called [mymodule1].
 myfunc() called.
after myfunc called [mymodule1].
before myfunc2 called [mymodule2].
 myfunc2() called.
after myfunc2 called [mymodule2].
