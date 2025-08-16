#!/bin/bash
set -e

# 默认 UID/GID
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# 确保组存在
if ! getent group "$PGID" >/dev/null; then
    groupadd -g "$PGID" mcgroup
fi

# 确保用户存在
if ! id -u "$PUID" >/dev/null 2>&1; then
    useradd -u "$PUID" -g "$PGID" -s /bin/bash -M minecraft
    TARGET_USER=minecraft
else
    TARGET_USER=$(id -nu "$PUID")
fi

# 修正挂载卷权限
for dir in /minecraft /server /scripts; do
    if [ -d "$dir" ]; then
        chown -R $PUID:$PGID "$dir"
    fi
done

# JVM 参数（来自环境变量）
JAVA_OPTS=${JAVA_OPTS:-"-Xms2G -Xmx4G"}

echo "正在以 UID:$PUID GID:$PGID 启动 Minecraft 服务器..."
echo "Java 参数: $JAVA_OPTS"

cd /minecraft
exec gosu "$TARGET_USER" java $JAVA_OPTS -jar /server/server.jar nogui
