# MyMCServer Docker 服务器

这是一个使用 Docker 和 Docker Compose 构建的通用 Minecraft 服务器项目，支持多种服务器核心。

## 项目结构

```
MyMCServer/
├── Dockerfile              # Docker 镜像构建文件 (支持自定义 Java 版本)
├── docker-compose.yml      # Docker Compose v2 配置文件
├── start.sh                # 服务器启动脚本
├── .env.example            # 环境变量配置示例
├── manage.sh               # 服务器管理脚本
├── SERVER_JAR_EXAMPLES.md  # 服务器核心使用示例
└── minecraft/              # 服务器运行目录 (直接挂载)
    ├── server.jar          # 当前使用的服务器核心 (必需)
    ├── eula.txt            # Minecraft EULA 同意文件
    ├── server.properties   # 服务器配置文件
    ├── world/              # 世界文件
    ├── plugins/            # 插件目录
    ├── mods/               # 模组目录
    ├── config/             # 配置文件
    ├── logs/               # 日志文件
    └── ...                 # 其他服务器文件
```

## 支持的服务器核心

本项目支持所有主流 Minecraft 服务器核心：

- **Vanilla** - 原版服务器
- **Paper** - 高性能 Bukkit/Spigot 服务器 (推荐)
- **Spigot** - 经典插件服务器
- **Forge** - 模组服务器
- **Fabric** - 轻量模组服务器  
- **NeoForge** - 新一代 Forge
- **自定义服务器** - 如 Youer、Mohist 等

