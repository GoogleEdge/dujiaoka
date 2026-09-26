FROM webdevops/php-nginx:7.4

ENV WEB_DOCUMENT_ROOT=/app/public
ENV APP_ENV=production
ENV APP_DEBUG=false

WORKDIR /app
COPY . /app

# 删除宿主机的 .env，防止错误的格式导致 composer 构建失败
RUN rm -f .env

RUN [ "sh", "-c", "composer install --ignore-platform-reqs --no-dev" ]
RUN [ "sh", "-c", "chmod -R 777 /app" ]
RUN echo "#!/bin/bash\nphp artisan queue:work >/tmp/work.log 2>&1 &\nsupervisord" > /app/start.sh
RUN chmod +x /app/start.sh

CMD [ "sh", "-c", "/app/start.sh" ]
