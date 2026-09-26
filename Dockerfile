FROM webdevops/php-nginx:7.4

# 【核心修复】强制 Nginx 将网站根目录指向 /app/public
ENV WEB_DOCUMENT_ROOT=/app/public
ENV APP_ENV=production
ENV APP_DEBUG=false

WORKDIR /app
COPY . /app

# 安装依赖（加上 --no-dev 减小镜像体积，加快构建）
RUN [ "sh", "-c", "composer install --ignore-platform-reqs --no-dev" ]

# 设置目录权限
RUN [ "sh", "-c", "chmod -R 777 /app" ]

# 生成启动脚本，确保有执行权限
RUN echo "#!/bin/bash\nphp artisan queue:work >/tmp/work.log 2>&1 &\nsupervisord" > /app/start.sh
RUN chmod +x /app/start.sh

CMD [ "sh", "-c", "/app/start.sh" ]
