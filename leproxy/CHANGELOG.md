# 更新日志 (Changelog)

## 0.2.2 (2018-07-17)

*   特性：支持监听 Unix 域套接字 (UDS) 路径，并支持通过 Unix 域套接字 (UDS) 路径进行代理转发/链式调用。
    (#51 由 @clue 提交)

    LeProxy 现在支持在 Unix 域套接字 (UDS) 路径上进行监听，以及通过 UDS 路径进行代理转发/链式调用，这两者均被视为高级用法：

    ```bash
    $ php leproxy.php ./proxy.socket

    $ php leproxy.php :8080 --proxy http+unix://./proxy.socket
    ```

*   特性：更新 HTTP 依赖，拒绝分块 (chunked) 请求，并将 ReactPHP 更新至稳定的 LTS 版本。
    (#49 和 #50 由 @clue 提交)

## 0.2.1 (2018-03-09)

*   特性：更新 Socket 和 DNS 依赖，支持在所有受支持的平台加载系统默认的 DNS 配置。
    (包括 Unix/Linux/Mac/Docker/WSL 上的 `/etc/resolv.conf` 以及 Windows 上的 WMIC)
    (#45 由 @clue 提交)

    这意味着连接到由本地 DNS 服务器管理的主机（例如公司 DNS 服务器或使用 Docker 容器时）现在将在所有平台上如预期般工作，无需任何更改。

*   修复：更新 HTTP 和 HttpClient 依赖，包括多项 HTTP 处理改进（支持多个响应 Cookie、更大的请求头、以及忽略损坏的响应 Transfer-Encoding）。
    (#46 由 @clue 提交)

*   通过更新 HttpClient 依赖并移除不需要的依赖来减小包体积。
    (#47 由 @clue 提交)

*   改进测试套件，增加了与更新后的 react/promise-stream 的向前兼容性，并通过跳过所有 IPv6 测试修复了 Travis 构建。
    (#42 由 @WyriHaximus 提交，#44 由 @clue 提交)

## 0.2.0 (2017-09-01)

*   特性：增加 `--block=<target>` 参数用于黑名单目标地址，并增加 `--block-hosts=<path>` 参数用于批量屏蔽多个主机；采用更正规的 HTTP/SOCKS 状态码，并改进错误报告与分析。
    (#24, #40 和 #41 由 @clue 提交)

    例如，以下命令允许你屏蔽所有明文 HTTP 请求，并将 LeProxy 用作一个简单但有效的广告拦截器：

    ```bash
    $ php leproxy.php --block=:80 --block-hosts=hosts-ads.txt
    ```

*   特性：通过 commander 验证所有参数，而不是直接抛出异常。
    (#37 由 @clue 提交)

*   特性：更新 Socket 依赖以在所有平台上支持 hosts 文件，并更新 DNS 依赖以修复 Windows DNS 超时问题。
    (#38 和 #39 由 @clue 提交)

## 0.1.0 (2017-08-01)

* 第一个标记版本 :shipit:
