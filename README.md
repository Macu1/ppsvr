# ppsvr
p p svr


id dispatch没用,16位的orderID可以编码为 8位时间信息 4位路由信息 4位循环自增值
如：07152213 0022 1593 
前提条件：
1.任意路由下,每秒的订单数量不会超过9999条
2.需要定期对订单做备份归档,跨年后时间信息会发生环回


