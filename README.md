# MyMCServer Docker 服务器

🎮 基于 Docker 的 Minecraft 服务器解决方案，支持多种服务器核心和 Java 版本。

## ✨ 特性

- 🐳 Docker 容器化部署，开箱即用
- ☕ 支持多版本 Java (8/11/17/21/22)
- ⚡ 内置性能优化的 JVM 参数
- 🔧 灵活的环境变量配置
- 📦 支持任意 Minecraft 服务器核心

## 🚀 快速开始

### 前置要求
- Docker 和 Docker Compose

### 1. 准备服务器文件
```bash
# 创建 minecraft 目录
mkdir minecraft

# 下载并放置服务器核心文件 (以 Paper 为例)
wget -O minecraft/server.jar https://fill-data.papermc.io/v1/objects/d310c61899acc608b683515c5c7ef929774bfd1b90262dac965e76c7e9ea8d22/paper-1.21.8-30.jar

# 或者使用其他服务器核心
# cp your-server.jar minecraft/server.jar
```

### 2. 配置环境 (可选)
```bash
# 复制环境配置模板
cp .env.example .env

# 编辑配置 (可选)
nano .env
```

### 3. 启动服务器
```bash
# 构建并启动 (首次运行)
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务器
docker-compose down
```

### 4. 首次设置
```bash
# 同意 EULA
echo "eula=true" > minecraft/eula.txt

# 重新启动
docker-compose up -d
```

## ⚙️ 配置说明

| 环境变量 | 默认值 | 说明 |
|---------|--------|------|
| `JAVA_VERSION` | `21` | Java 版本 |
| `PUID` | `1000` | 容器用户 UID |
| `PGID` | `1000` | 容器用户 GID |
| `JAVA_OPTS` | `-Xms2G -Xmx4G ...` | JVM 参数 |
| `SERVER_PORT` | `25565` | 服务器端口 |

## 📁 目录结构
```
minecraft/              # 服务器文件目录
├── server.jar          # 服务器核心文件
├── server.properties   # 服务器配置
├── eula.txt           # EULA 协议
├── world/             # 世界文件
├── plugins/           # 插件目录 (Bukkit/Spigot/Paper)
├── mods/              # 模组目录 (Forge/Fabric)
└── logs/              # 日志文件
```

## 🛠️ 常用命令

```bash
# 启动服务器
docker-compose up -d

# 停止服务器
docker-compose down

# 重启服务器
docker-compose restart

# 查看实时日志
docker-compose logs -f

# 进入容器终端
docker-compose exec minecraft-server bash

# 执行服务器命令
docker-compose exec minecraft-server minecraft-command "say Hello World"

# 备份世界文件
tar -czf backup-$(date +%Y%m%d).tar.gz minecraft/

```

## 🔧 进阶配置

### 自定义 JVM 参数
编辑 `.env` 文件中的 `JAVA_OPTS`：
```bash
JAVA_OPTS=-Xms4G -Xmx8G -XX:+UseG1GC
```


## 📝 注意事项

- ⚠️ 首次启动前必须放置 `server.jar` 文件
- ⚠️ 首次启动后需要同意 EULA 协议
- ⚠️ 服务器数据保存在 `minecraft/` 目录，请注意备份
- ⚠️ 默认内存配置为 2G-4G，可根据需要调整
- ⚠️ 确保防火墙开放 25565 端口

## 🐛 故障排除

### 常见问题

**2. 内存不足**
```bash
# 在 .env 中调整内存
JAVA_OPTS=-Xms1G -Xmx2G
```

**3. 端口被占用**
```bash
# 在 .env 中更改端口或者直接修改docker-compose.yml
SERVER_PORT=25566
```

**4. 服务器无法启动**
```bash
# 查看详细日志
docker-compose logs minecraft-server
```

## 📄 许可证

本项目基于 MIT 许可证开源。

