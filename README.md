# ppsvr
p p svr


id dispatch没用,16位的orderID可以编码为 8位时间信息 4位路由信息 4位循环自增值
如：07152213 0022 1593 
前提条件：
1.任意路由下,每秒的订单数量不会超过9999条
2.需要定期对订单做备份归档,跨年后时间信息会发生环回


重新思考了一下,由于订单系统还是需要保证可用性,那么如果内网发生异常
还是会出现一些数据的问题,所以继续简化,就是在具体的逻辑服上做记录和校验


