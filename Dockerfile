# Используем официальный образ n8n как базу
FROM n8nio/n8n:latest

# Включаем установку сторонних пакетов
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
# Отключаем лишнюю телеметрию
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_VERSION_NOTIFICATIONS_ENABLED=false

# Устанавливаем рабочую директорию внутри образа
WORKDIR /data

# Переключаемся на пользователя node (id 1000), от имени которого работает Amvera
USER root

# Копируем только файлы зависимостей в корень WORKDIR (/data) 
# Это позволяет закешировать слои npm и не пересобирать их при каждом изменении кода
COPY package*.json ./

# Устанавливаем зависимости ВАШЕГО проекта (включая вашу ноду из GitHub)
RUN cd /data && \
    npm install git+https://github.com/allexkoldun/n8n-experiment1.git --unsafe-perm

# Возвращаем права непривилегированного пользователя (требование безопасности Amvera)
USER node

# Копируем остальной код вашего приложения (если он есть)
# Если кроме Dockerfile и package.json ничего нет — эту строку можно удалить
COPY --chown=node:node . .

# Указываем точку входа через абсолютный путь к бинарнику
CMD ["node", "/home/node/.n8n/node_modules/n8n/bin/n8n", "start"]
