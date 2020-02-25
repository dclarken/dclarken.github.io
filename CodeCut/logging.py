import logging

def logging_out(logFilename):
  logging.basicConfig(level=logging.DEBUG,    #定义输出到日志文件的log级别，大于此级别的都被输出
                      format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',        # 日志格式
                      datefmt='%Y-%m-%d %H:%M:%S',    # 时间格式：2018-11-12 23:50:21
                      filename=logFilename,    # 日志的输出路径
                      filemode='a')             # 追加模式，写入模块“w”或者“a‘
#使用方法
logging.debug('debug message')
logging.info('info message')
logging.warning('warning message')
logging.error('error message')
logging.critical('critical message')                      
                      
def logger_out(logFilename):  
  #Logger类,	日志器，提供了应用程序可一直使用的接口
  #Handler将 logger 产生的日志发送到指定的路径下（例如可以是终端，也可以是文件）
  #Formatter	定义日志格式
  #使用组件记录日志的大致步骤如下：
  #1）logging.getLogger() 获取 logger对象
  #2）创建一个或多个 handler，用于指定日志信息的输出流向
  #3）创建一个或多个 formatter，指定日志的格式，并分别将 formatter 绑定到logger对象上
  #4）将 handler 绑定到logger对象上
  #5）logger.setLevel(logging.DEBUG) 设置日志级别，也可以分别对两个hander设置日志级别
  #6) 最后便可使用 logger对象 记录日志~
  
  #获取logger对象，需要在main函数中定义，否则会报错找不到全局变量
  logger=logging.getLogger(__name__)
  #设置logger的日志级别
  logger.setLevel(logging.DEBUG)
  #创建一个或者多个formatter，两个handler使用相同的日志格式
  formatter=logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
  
  #创建一个文件handler，用于写入日志文件
  handler=logging.FileHandler(logFilename)
  #设置文件handler的日志级别
  handler.setLevel(logging.DEBUG)
  
  #再创建一个流handler，用于输出到控制台
  console=logging.StreamHandler()
  #设置流handler的日志级别
  console.setLevel(logging.DEBUG)
  
  # 绑定formatter到handler上
  handler.setFormatter(formatter)
  console.setFormatter(formatter)

  #绑定文件/流handler到logger对象上
  logger.addHandler(handler) #文件输出
  logger.addHandler(console) #控制台输出

#使用方法
logger.debug('logger debug message')
logger.info('logger info message')
logger.warning('logger warning message')
logger.error('logger error message')
logger.critical('logger critical message')

#参考地址：https://blog.51cto.com/ljbaby/2316617
