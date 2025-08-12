#!/bin/bash

# MyMCServer Docker 镜像构建脚本
# 用于构建 Minecraft 服务器 Docker 镜像

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "MyMCServer Docker 镜像构建脚本 (使用 Docker Buildx)"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -j, --java-version VERSION  指定 Java 版本 (默认: 21)"
    echo "  -t, --tag TAG              指定镜像标签 (默认: my-minecraft-server)"
    # echo "  -u, --uid UID              指定 minecraft 用户 UID (默认: 1005)"
    # echo "  -g, --gid GID              指定 minecraft 用户 GID (默认: 1005)"
    echo "  --no-cache                 不使用构建缓存"
    echo "  -h, --help                 显示此帮助信息"
    echo ""
    echo "支持的 Java 版本: 8, 11, 17, 21, 22"
    echo ""
    echo "示例:"
    echo "  $0                         # 使用默认设置构建"
    echo "  $0 -j 17 -t mc-server:1.0 # 使用 Java 17 构建并标记为 mc-server:1.0"
    echo "  $0 -u 1001 -g 1001        # 使用自定义 UID/GID 构建"
    echo "  $0 --no-cache              # 不使用缓存构建"
    echo ""
    echo "注意: 此脚本使用 Docker Buildx 进行构建，如果不可用会自动尝试设置。"
}

# 默认参数
JAVA_VERSION="21"
IMAGE_TAG="my-minecraft-server"
# PUID="1005"
# PGID="1005"
NO_CACHE=""

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -j|--java-version)
            JAVA_VERSION="$2"
            shift 2
            ;;
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        -u|--uid)
            PUID="$2"
            shift 2
            ;;
        -g|--gid)
            PGID="$2"
            shift 2
            ;;
        --no-cache)
            NO_CACHE="--no-cache"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "未知参数: $1"
            show_help
            exit 1
            ;;
    esac
done

# # 验证 UID 和 GID
# if ! [[ "$PUID" =~ ^[0-9]+$ ]] || [ "$PUID" -lt 1 ]; then
#     print_error "无效的 UID: $PUID"
#     exit 1
# fi

# if ! [[ "$PGID" =~ ^[0-9]+$ ]] || [ "$PGID" -lt 1 ]; then
#     print_error "无效的 GID: $PGID"
#     exit 1
# fi

# 验证 Java 版本
case $JAVA_VERSION in
    8|11|17|21|22)
        print_info "使用 Java 版本: $JAVA_VERSION"
        ;;
    *)
        print_error "不支持的 Java 版本: $JAVA_VERSION"
        print_info "支持的版本: 8, 11, 17, 21, 22"
        exit 1
        ;;
esac

# 检查 Docker 是否可用
if ! command -v docker &> /dev/null; then
    print_error "Docker 未安装或不可用"
    exit 1
fi

# 检查 Docker Buildx 是否可用
if ! docker buildx version &> /dev/null; then
    print_warning "Docker Buildx 不可用，尝试安装..."
    # 创建并使用 buildx 实例
    docker buildx create --use --name mybuilder 2>/dev/null || true
fi

# 检查 Dockerfile 是否存在
if [[ ! -f "Dockerfile" ]]; then
    print_error "Dockerfile 不存在"
    exit 1
fi

print_info "开始构建 Docker 镜像..."
print_info "Java 版本: $JAVA_VERSION"
print_info "镜像标签: $IMAGE_TAG"
# print_info "Minecraft UID: $PUID"
# print_info "Minecraft GID: $PGID"
print_info "构建参数: $NO_CACHE"

# 构建 Docker 镜像 - 使用 buildx
print_info "执行 Docker Buildx 构建..."
BUILD_ARGS="--build-arg JAVA_VERSION=$JAVA_VERSION"
if [[ -n "$NO_CACHE" ]]; then
    BUILD_ARGS="$BUILD_ARGS --no-cache"
fi

if docker buildx build \
    $BUILD_ARGS \
    --tag $IMAGE_TAG \
    --load \
    . ; then
    print_success "Docker 镜像构建完成!"
    print_info "镜像标签: $IMAGE_TAG"
    
    # 显示镜像信息
    print_info "镜像详情:"
    docker images | grep -E "(REPOSITORY|$IMAGE_TAG)" || docker images $IMAGE_TAG
else
    print_error "Docker 镜像构建失败!"
    exit 1
fi

print_success "构建脚本执行完成!"
