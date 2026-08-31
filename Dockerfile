# Используем легковесный LTS-образ Node.js внутри официального образа n8n
FROM n8nio/n8n:latest

# Включаем разрешение на установку сторонних пакетов (обязательно)
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
# Отключаем телеметрию по желанию
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_VERSION_NOTIFICATIONS_ENABLED=false

# Устанавливаем переменную для пути к данным, чтобы они сохранялись между перезапусками
ENV N8N_USER_FOLDER=/data

# Копируем файлы package.json для кеширования слоев npm при сборке
COPY package*.json ./

# Если у вас есть кастомные ноды, устанавливаем их сейчас
# RUN cd /home/node && npm install git+https://github.com/ваш_ник/репозиторий-с-нодой.git

WORKDIR /data
USER root

# Меняем владельца папки данных на пользователя node (uid 1000), иначе amvera не сможет писать логи
RUN chown -R node:node /data

USER node

CMD ["n8n", "start"]
