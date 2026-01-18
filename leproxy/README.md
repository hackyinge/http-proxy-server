# LeProxy

[![CI 状态](https://github.com/leproxy/leproxy/actions/workflows/ci.yml/badge.svg)](https://github.com/leproxy/leproxy/actions)
[![GitHub 下载量](https://img.shields.io/github/downloads/leproxy/leproxy/total?color=blue&label=downloads%20on%20GitHub)](https://github.com/leproxy/leproxy/releases)
[![Packagist 安装量](https://img.shields.io/packagist/dt/leproxy/leproxy?color=blue&label=installs%20on%20Packagist)](https://packagist.org/packages/leproxy/leproxy)  

LeProxy 是一个为所有人设计的 HTTP/SOCKS 代理服务器！

LeProxy 旨在提供匿名上网、增强安全性与隐私，并绕过地理限制（Geoblocking）。
它让你能够像互联网应有的那样享受网络，在旅行时访问你最喜欢的在线视频平台，而不再受令人恼火的国家区域限制。

LeProxy 是一个功能强大、轻量、快速且易于使用的代理服务器。你可以将其托管在自己的服务器或家庭电脑上，然后从任何地方访问。
它支持可选的身份认证，因此你可以放心地将服务器实例分享给家人和朋友，而无需担心第三方滥用。
它通过在单个监听端口上同时接受通用的 HTTP 和 SOCKS 代理协议，提供了与大量客户端协议和服务的兼容性。

**目录**

* [安装](#安装)
* [使用方法](#使用方法)
* [客户端配置](#客户端配置)
* [开发说明](#开发说明)
* [开源协议](#开源协议)

> 请注意，这是早期的 beta 版本，LeProxy 目前仍在积极开发中。
> 未来将添加更多新功能！

## 安装

LeProxy 仅需要 PHP 环境。
*高度推荐使用 PHP 7+*，但它可以在任何使用 PHP 5.4+ 或 HHVM 的系统上运行。
如果你还没有安装 PHP，在最近的 Ubuntu/Debian 系统上，只需运行：

```bash
$ sudo apt-get install php7.0-cli
```

你可以直接从我们的 [发布页面 (Releases)](https://github.com/leproxy/leproxy/releases) 下载最新的 `leproxy-{version}.php` 文件。
[最新版本](https://github.com/leproxy/leproxy/releases/latest) 总是可以通过以下方式下载：

```bash
$ curl -OL https://leproxy.org/leproxy-latest.php
```

下载好 `leproxy-{version}.php` 文件了？
搞定！！是不是非常简单？

> LeProxy 以单 PHP 文件的形式分发，包含了运行 LeProxy 所需的一切。
> 下面的示例假设你已将该文件在本地保存为 `leproxy.php`，但你可以使用任何你喜欢的名称。
> 如果你对该文件的技术细节感兴趣，可以查看下面的 [开发说明](#开发说明) 部分。

## 使用方法

[安装](#安装)完成后，只需运行以下命令即可启动 LeProxy：

```bash
$ php leproxy.php 
```

默认情况下，LeProxy 将监听公共地址 `0.0.0.0:8080`。
如果你想监听其他地址，可以传入明确的监听地址。
如果 LeProxy 无法在给定地址监听，它会报告错误。你可以尝试另一个地址，或者使用端口 `0` 让系统自动挑选一个空闲端口。
例如，如果你不想让外部访问 LeProxy，只想监听本地接口：

```bash
$ php leproxy.php 127.0.0.1:8080
```

> 监听地址必须采用 `ip:port` 或仅 `ip` 或 `:port` 的形式，上述默认值会自动生效（你也可以使用 Unix 域套接字路径）。

注意，LeProxy 默认运行在受保护模式下，因此它仅转发来自本地主机的请求，不能被滥用作开放代理。
如果你已确保只有合法用户可以访问你的系统，可以传递 `--allow-unprotected` 标志以转发来自所有主机的请求。
如果你想要求客户端发送用户名/密码认证信息，可以将其作为监听地址的一部分：

```bash
$ php leproxy.php username:password@0.0.0.0:8080
```

> 如果用户名或密码包含特殊字符，请确保使用 URL 编码值（百分比编码），例如 `p@ss` 应写为 `p%40ss`。

默认情况下，LeProxy 允许连接到每个传入代理请求中给出的任何目标地址。
如果你想阻止访问某些目标主机和/或端口，可以通过传递 `--block=<destination>` 参数将它们加入黑名单。
可以指定任意数量的目标地址。
每个目标地址可以采用 `host:port` 或仅 `host` 或 `:port` 的形式，且 `host` 可能包含 `*` 通配符以匹配任何内容。
每个主机的子域将自动被阻止。
例如，以下命令可用于阻止访问 `youtube.com`（及其子域，如 `www.youtube.com`）以及所有主机上的 80 端口（标准明文 HTTP 端口）：

```bash
$ php leproxy.php --block=youtube.com --block=*:80
```

> 请注意，阻止列表作用于传入代理请求中给出的目标地址。一些[客户端](#客户端配置)使用本地 DNS 解析，不传输主机名，而仅传输解析后的目标 IP 地址（这在 SOCKS 协议中尤为常见）。请确保相应地配置你的客户端使用远程 DNS 解析，和/或同时阻止相关的 IP 地址。

除了将每个阻止的目标作为单独的命令行参数列表之外，你还可以传递 `hosts` 文件的路径。
你可以自己创建一个 hosts 文件映射，如果你只想阻止某些主机，或者你可以使用许多优秀的 hosts 文件之一。
例如，你可以从 https://github.com/StevenBlack/hosts 下载 hosts 文件（该文件汇集了来自 adaway.org、mvps.org、malwaredomainlist.com、someonewhocares.org 等多个精心维护的来源），将其作为一种简单有效的广告拦截器。
注意，LeProxy 仅会阻止映射到 IP `0.0.0.0` 的域名（及其所有子域名），并忽略所有其他条目：

```bash
$ php leproxy.php --block-hosts=hosts.txt
```

默认情况下，LeProxy 为每个传入的代理请求创建到目标地址的直接连接。
在这种模式下，目的地看不到原始客户端地址，而只能看到你的 LeProxy 实例的地址。
如果你想要更高程度的匿名性，可以使用**代理转发 (Proxy Forwarding)**，连接将通过另一个上游代理服务器进行隧道传输。
如果你使用的上游代理地址经常更改（例如使用公共代理），但你不希望每次都重新配置客户端，或者如果你的上游代理需要你的客户端不支持的功能（例如需要认证或不同的代理协议），这也非常有用。
你只需在监听地址后面传入上游代理服务器地址作为另一个 URL 参数即可，如下所示：

```bash
$ php leproxy.php --proxy=socks://user:pass@127.0.0.1:8080
```

> 上游代理服务器 URI 必须包含主机名或 IP，且除非代理恰好使用默认端口 `8080`，否则应包含端口（你也可以使用 Unix 域套接字路径）。
> 如果未给出协议前缀（scheme），将假设为 `http://`。
> 如果未给出端口，无论何种协议前缀，都将假设为端口 `8080`。
> `http://` 和 `socks[5]://` 协议支持可选的用户名/密码认证，如上例所示。

通过追加额外的上游代理服务器，这可以有效地变成**代理链 (Proxy Chaining)**，其中每个传入的代理请求将按从左到右的顺序通过所有上游代理服务器构成的链条进行转发。
这以增加延迟为代价，但可能提供更高程度的匿名性，因为链条中的每个代理服务器只能看到其直接通信伙伴，而目的地只能看到链条中的最后一个代理服务器：

```bash
$ php leproxy.php --proxy=127.1.1.1:8080 --proxy=127.2.2.2:8080 --proxy=127.3.3.3:8080
```

默认情况下，LeProxy 会在控制台输出 (STDOUT) 中为每次连接尝试打印一条日志消息，以便于调试和分析。
出于隐私原因，它本身不会持久化（存储）这些日志消息。
如果你不希望 LeProxy 记录任何内容，也可以传递 `--no-log` 标志。
如果你想将日志持久化到日志文件，可以使用标准的操作系统设施（如 `tee`）将输出重定向到文件：

```bash
$ php leproxy.php | tee -a leproxy.log
```

## 客户端配置

LeProxy 运行后，你就可以开始在几乎任何客户端软件中使用它。
下面的示例假设你想使用网络浏览器，但 LeProxy 实际上可以用于任何提供代理支持的客户端软件，例如电子邮件或即时通讯客户端。

大多数客户端都在其设置/首选对话框中提供了手动配置代理服务器的选项。
你只需设置上述配置的监听地址详情：

* 协议 (Protocol)：HTTP 或 SOCKS
* 服务器 (Server)：127.0.0.1（或运行 LeProxy 的公网主机名或 IP）
* 端口 (Port)：8080

> 请注意，这些设置必须根据你的实际网络设置进行调整。如果你未能提供正确的设置，后续连接将无法成功。在这种情况下，只需再次删除或禁用这些设置即可。当你漫游在另一个网络或代理服务器暂时不可用时，情况也是如此。

许多客户端（特别是网络浏览器和移动电话）还支持通过指定 PAC URL 进行代理自动配置 (PAC)。
使用 PAC 通常是有益的，因为如果无法连接到 PAC URL，大多数客户端会简单地忽略代理设置，例如当你漫游在另一个网络或代理服务器暂时不可用时。
只需按以下格式使用到你的 LeProxy 实例的 URL：

```
http://127.0.0.1:8080/pac
```

> 请注意，这些设置必须根据你的实际网络设置进行调整。如果你未能提供正确的设置，你可能无法建立进一步的连接，因为大多数客户端会简单地忽略无效设置。如果你的客户端不允许这样做，只需再次删除或禁用这些设置。LeProxy 的 PAC 文件会指示你的客户端对所有公共 HTTP 请求使用 LeProxy 作为 HTTP 代理。这意味着解析为本地网络 IP 的主机名仍将使用直接连接，而不通过代理。

## 开发说明

LeProxy 是一个[开源项目](#开源协议)，鼓励所有人参与其开发。
你是否有兴趣了解 LeProxy 底层是如何工作的，或者想要为 LeProxy 的开发做出贡献？
那么本节就是为你准备的！

安装 LeProxy 的推荐方式是克隆（或下载）此存储库，并使用 [Composer](http://getcomposer.org) 下载其依赖项。
因此，你需要安装 PHP、git 和 curl。
例如，在最近的 Ubuntu/Debian 系统上，只需运行：

```bash
$ sudo apt-get install php7.0-cli git curl
$ git clone https://github.com/leproxy/leproxy.git
$ cd leproxy
$ curl -s https://getcomposer.org/installer | php
$ sudo mv composer.phar /usr/local/bin/composer
$ composer install
```

就这样完成了！
现在你应该可以通过运行 `leproxy.php` 文件来直接运行 LeProxy 的开发版本，如下所示：

```bash
$ php leproxy.php
```

更多详情请参阅 [使用方法](#使用方法)。

LeProxy 使用了一套复杂的测试套件进行功能测试和集成测试。
要运行测试套件，请进入项目根目录并运行：

```bash
$ vendor/bin/phpunit
```

如果你想将 LeProxy 分华为单个独立的发布文件，你可以将项目编译为单个文件，如下所示：

```bash
$ php compile.php
```

> 请注意，编译会暂时卸载所有开发依赖以进行分发，然后重新安装完整的依赖项。如果你之前已经安装过其依赖项，这应该只需要一两秒钟。编译脚本可选地接受版本号（`VERSION` 环境变量）和输出文件名，否则它将尝试查找最新的发布标签，例如 `leproxy-1.0.0.php`。

除上述测试套件外，LeProxy 还使用了一个简单的基于 bash/curl 的验收测试设置，也可用于检查生成的发布文件：

```bash
$ tests/acceptance.sh
```

> 请注意，验收测试将尝试在项目目录中查找 `leproxy*.php` 文件以进行测试。你可以选择提供要测试的输出文件名。

对你的本地开发版本进行了一些更改？
一定要让世界知道！:shipit:
我们欢迎 PR，并期待收到你的反馈！

祝编码愉快！

## 开源协议

LeProxy 是一个在受宽松的 [MIT 协议 (MIT license)](LICENSE) 保护下发布的开源项目。

LeProxy 是站在巨人的肩膀上的。
如果没有它所基于的优秀开源项目，构建像 LeProxy 这样的项目可能是不可能的。
特别是，它使用 [ReactPHP](http://reactphp.org/) 来实现其快速、事件驱动的架构。

它的所有依赖项都通过 Composer 管理，更多详情请参阅 [开发说明](#开发说明)。
如果你正在使用 [开发版本](#开发说明)，你可以运行 `$ composer licenses --no-dev` 获取所有运行时依赖项及其对应协议的列表。
所有这些要求都捆绑到了单个独立的发布文件中。
