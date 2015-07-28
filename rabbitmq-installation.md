# RabbitMQ installation

标签（空格分隔）： rabbit mq erlang centos

---

##  安装Erlang

 1. 添加Erlang Solutions key 支持
    rpm --import http://binaries.erlang-solutions.com/debian/erlang_solutions.asc
 2. 将erlang的repo文件添加到/ete/yum.repos.d/下 
   
    - wget
   http://binaries.erlang-solutions.com/rpm/centos/erlang_solutions.repo
    - mv erlang_solutions.repo /etc/yum.repos.d/  
 3. 添加 RPMforge 支持  (64位) 
   - wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
   - 导入key： rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt 
   - 安装 RPMforge（64位）：rpm -i rpmforge-release-0.5.2-2.el6.rf.*.rpm  
 4. 安装更新
   - yum install
   - yum install esl-erlang
 5. 确认安装成功
   - erl
   - io.format("hello world~n")

## RabbitMQ
  

 1. 安装 yum install rabbitmq-server
 2. 启动 service rabbitmq-server start
 3. 添加到启动项 chkconfig rabbitmq-server on

## 参考

 1. http://www.erlang-solutions.com/section/132/download-erlang-otp  
 2. http://wiki.centos.org/AdditionalResources/Repositories/RPMForge#head-f0c3ecee3dbb407e4eed79a56ec0ae92d1398e01 
