# LeProxy Docker 部署文档

## 快速部署

### 1. 配置文件

当前项目已配置为使用预编译的 `leproxy-0.2.2.php` 文件，确保构建速度。

**docker-compose.yml**:
```yaml
services:
  leproxy:
    build: .
    ports:
      - "50000:50000"
    restart: unless-stopped
    command: ["Admin:Admin123456.,.@0.0.0.0:50000"]
```

### 2. 启动命令

```bash
docker-compose up -d --build
```

## 运维说明

- **公网域名**: `proxy.hackyin.com`
- **监听端口**: `50000` (容器内与宿主机一致)
- **认证账号**: `Admin` / `Admin123456.,.`
- **日志查看**: `docker-compose logs -f`

## 安全配置

1. **认证模式**: 已启用 `username:password@ip:port` 格式，LeProxy 会自动开启认证。
2. **非 Root 运行**: Dockerfile 中已通过 `USER leproxy` 指定普通用户运行，增强容器安全性。
3. **防火墙建议**: 仅放行公网公用的 50000 端口，内部通信可维持在 Docker 网络内。

## 使用案例

请参考 [PROXY_USAGE.md](./PROXY_USAGE.md) 获取详细的客户端配置示例。
