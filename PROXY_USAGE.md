# LeProxy 代理使用指南 (公网认证版)

## 代理服务器信息

| 配置项 | 值 |
|--------|-----|
| **代理地址** | `proxy.hackyin.com:50000` |
| **用户名** | `Admin` |
| **密码** | `Admin123456.,.` |
| **协议** | HTTP / SOCKS5 |
| **认证方式** | Basic Auth |

---

## 一、命令行使用

### 1. 设置环境变量 (推荐)

```bash
# 设置带认证的 HTTP/HTTPS 代理 (对于包含特殊字符的密码，强烈建议在 shell 中使用单引号)
export proxy_url='http://Admin:Admin123456.,.@proxy.hackyin.com:50000'

export http_proxy=$proxy_url
export https_proxy=$proxy_url
export HTTP_PROXY=$proxy_url
export HTTPS_PROXY=$proxy_url

# 测试代理是否生效
curl https://httpbin.org/ip
```

### 2. 单次命令使用

```bash
# curl (注意密码中包含特殊字符，建议加引号或使用 -U)
curl -x http://proxy.hackyin.com:50000 -U "Admin:Admin123456.,." https://httpbin.org/ip

# 使用完整 URL 格式 (同样建议加单引号)
curl -x 'http://Admin:Admin123456.,.@proxy.hackyin.com:50000' https://httpbin.org/ip
```

### 3. Git 配置

```bash
git config --global http.proxy 'http://Admin:Admin123456.,.@proxy.hackyin.com:50000'
git config --global https.proxy 'http://Admin:Admin123456.,.@proxy.hackyin.com:50000'
```

---

## 二、Docker 使用

### 1. Docker daemon 全局代理 (服务器级别)

编辑 `/etc/systemd/system/docker.service.d/http-proxy.conf`:

```ini
[Service]
Environment="HTTP_PROXY=http://Admin:Admin123456.,.@proxy.hackyin.com:50000"
Environment="HTTPS_PROXY=http://Admin:Admin123456.,.@proxy.hackyin.com:50000"
Environment="NO_PROXY=localhost,127.0.0.1"
```

### 2. Docker Run 运行时

```bash
docker run -e http_proxy='http://Admin:Admin123456.,.@proxy.hackyin.com:50000' \
           -e https_proxy='http://Admin:Admin123456.,.@proxy.hackyin.com:50000' \
           my-image
```

---

## 三、其他工具

- **浏览器 (SwitchyOmega)**:
  - 代理协议: `HTTP`
  - 代理服务器: `proxy.hackyin.com`
  - 端口: `50000`
  - 点击“锁”图标输入用户名密码

- **Python (Requests)**:
```python
proxies = {
    "http": "http://Admin:Admin123456.,.@proxy.hackyin.com:50000",
    "https": "http://Admin:Admin123456.,.@proxy.hackyin.com:50000",
}
import requests
print(requests.get("https://httpbin.org/ip", proxies=proxies).text)
```

---

## 六、分流与规则配置 (如何实现“国内直连”)

默认情况下，`export` 后的代理会将所有流量发往 `proxy.hackyin.com`。如果你希望国内流量不绕路，可以采用以下配置：

### 1. 使用 `no_proxy` 排除列表
在设置代理的同时，明确指定哪些流量**不走代理**：

```bash
# 1. 设置代理
export http_proxy='http://Admin:Admin123456.,.@proxy.hackyin.com:50000'
export https_proxy=$http_proxy

# 2. 设置直连名单 (排除本地、内网网段、以及 .cn 域名)
export no_proxy='localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,.cn,aliyun.com,baidu.com,tencent.com'
```

### 2. 使用 LeProxy 内置 PAC 文件
在 Windows/Mac/Ubuntu 系统的 **“使用自动代理配置脚本 (PAC)”** 处填入：
`http://proxy.hackyin.com:50000/pac`

LeProxy 会自动下发规则，确保本地和内网地址不走代理。

---

## ❓ 常见问题 FAQ

**Q: 执行 `ping google.com` 怎么还是不通？**
A: `ping` 使用的是 ICMP 协议，不属于环境变量代理（HTTP/HTTPS/SOCKS）的管辖范围。请使用 `curl -I https://www.google.com` 来测试连通性。

**Q: 只有特定命令想走代理怎么办？**
A: 不要 export。在命令前直接加环境变量：
`http_proxy='http://Admin:Admin123456.,.@proxy.hackyin.com:50000' curl https://www.google.com`
