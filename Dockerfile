# 使用官方的 OpenJDK 镜像作为基础镜像，支持自定义版本
ARG JAVA_VERSION=21
FROM openjdk:${JAVA_VERSION}-jre-slim

# 设置工作目录
WORKDIR /minecraft

# 创建 minecraft 用户，避免使用 root 运行服务器
RUN groupadd -r minecraft && useradd -r -g minecraft minecraft

# 注意：server.jar 通过挂载提供，不在镜像中复制
# 这样可以灵活更换不同的服务器核心

# 创建基本目录结构
RUN mkdir -p /minecraft

# 创建启动脚本
COPY start.sh /minecraft/start.sh
RUN chmod +x /minecraft/start.sh

# 更改文件所有者
RUN chown -R minecraft:minecraft /minecraft

# 切换到 minecraft 用户
USER minecraft

# 暴露端口
EXPOSE 25565

# 简化卷挂载 - 直接挂载整个 minecraft 目录
VOLUME ["/minecraft"]

# 启动服务器
CMD ["./start.sh"]
