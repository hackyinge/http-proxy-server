# 使用本地预编译的 leproxy.php 文件
# LeProxy 0.2.2 兼容 PHP 5.4+,使用 PHP 7.4 以获得更好的兼容性
FROM php:7.4-cli-alpine

WORKDIR /app

# 复制预编译的 leproxy 文件
COPY leproxy-0.2.2.php ./leproxy.php

# Expose port
EXPOSE 50000

# 创建非 root 用户提升安全性
RUN addgroup -g 1000 leproxy && \
    adduser -D -u 1000 -G leproxy leproxy && \
    chown -R leproxy:leproxy /app

USER leproxy

# Run
ENTRYPOINT ["php", "leproxy.php"]
CMD ["0.0.0.0:50000", "--allow-unprotected"]
