#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import Queue
import threading
import time
'''
开启线程
'''
def startThreads(in_q, orderList, func, param1):
    print (orderList)
    print (type(orderList))
    for i in orderList:
        tasksNumber = len(i)
        if tasksNumber > 1:
            threads = []
            for unit in i:
                t = threading.Thread(target=func, args=(in_q, param1))
                threads.append(t)
            for t in threads:
                try:
                    t.start()
                except:
                    print ("Error when starting threads")
                    error_data = "Error when starting threads"
                    in_q.put(error_data)
                    sys.exit()
            for t in threads:
                t.join()
        else:
            unit = i[0]
            run(in_q, param1)

#单个线程的执行函数
def run(in_q, param1):
    try:
        print (in_q, param1)
    except:
        error_data = "Error in run"
        in_q.put(error_data)
        sys.exit()

def main(in_q, param1):
    startThreads(in_q, orderList, run, param1)

if __name__ == "__main__":
    #利用队列获取异常信息
    q = Queue.Queue() 
    #通过orderList确定是否开启线程
    orderList = [['order1', 'order2']]
    param1 = "test"
    main(q, param1)
    #队列有异常信息，主函数抛出异常
    try:
        queue_data = q.get(False)
    except:
        queue_data = None
    if queue_data:
        raise Exception(queue_data)
