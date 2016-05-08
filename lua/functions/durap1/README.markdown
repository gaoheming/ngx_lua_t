Name
====


 lua web framework based on ngx-openresty.


Status
======

Now it is still experimental and under early development.
And it powerd some app online.

NOTICE: This project is not maintained anymore and is not recommended for production environments.

注意：由于工作内容略有变更，时间也有限，这个项目一直没有持续更新，并不推荐大家使用 :)


Description
===========
简要介绍
1. 基本实现了 MVC 的小框架。支持多 APP，每个 APP 为一个目录，APP 之间相互独立

2. system 目录为框架代码

3. t 目录为测试集，由 test-nginx 驱动，测试 demo1 APP 的功能，需要完成 database，redis 初始化支持

4. blog 目录为相对完整 APP

5. router：自动路由，规则类似 CI，根据 ngx.var.router_uri 来映射 app/controller 目录下的 module，router_uri 类似 uri，在 nginx.conf 里赋值

6. model：在 system/database 下封装了 mysql, redis 的库，主要包含 connect，error log，以及 mysql 的 active record 封装
          每个 APP 有自己的 model 实现，在 app/model 目录下

7. controller：app/controller 目录下存放当前 APP 的 controller

9. loader：用来装在 APP 里的 module（controller，model，config，library，view），支持缓存

10. index.lua：框架的统一入口



