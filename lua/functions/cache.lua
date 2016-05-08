可以看出来，这个cache是worker级别的，不会在nginx wokers之间共享。并且，它是预先分配好key的数量，而shared dcit需要自己用key和value的大小和数量，来估算需要把内存设置为多少。+

如何选择？

shared.dict 使用的是共享内存，每次操作都是全局锁，如果高并发环境，不同worker之间容易引起竞争。所以单个shared.dict的体积不能过大。lrucache是worker内使用的，由于nginx是单进程方式存在，所以永远不会触发锁，效率上有优势，并且没有shared.dict的体积限制，内存上也更弹性，但不同worker之间数据不同享，同一缓存数据可能被冗余存储。
你需要考虑的，一个是Lua lru cache提供的API比较少，现在只有get、set和delete，而ngx shared dict还可以add、replace、incr、get_stale（在key过期时也可以返回之前的值）、get_keys（获取所有key，虽然不推荐，但说不定你的业务需要呢）；第二个是内存的占用，由于ngx shared dict是workers之间共享的，所以在多worker的情况下，内存占用比较少。

--https://moonbingbing.gitbooks.io/openresty-best-practices/content/ngx_lua/cache.html
