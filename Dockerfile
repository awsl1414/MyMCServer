# 使用官方的 OpenJDK 镜像作为基础镜像，支持自定义版本
ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-jre

# 设置工作目录
WORKDIR /minecraft

# # 定义用户和组ID，确保与宿主机权限一致
# ARG PUID=1005
# ARG PGID=1005

# 创建 minecraft 用户和组，指定固定的 UID 和 GID
# RUN groupadd -g ${PGID} minecraft && \
#     useradd -u ${PUID} -g minecraft -s /bin/bash -m minecraft


# 创建基本目录结构
RUN mkdir -p /minecraft /scripts /server

# 创建启动脚本
COPY start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# 更改文件所有者
# RUN chown -R minecraft:minecraft /minecraft /scripts /server

# 切换到 minecraft 用户
# USER minecraft

# 暴露端口
EXPOSE 25565

# 挂载
VOLUME /minecraft /scripts /server

# 启动服务器
CMD ["/scripts/start.sh"]
