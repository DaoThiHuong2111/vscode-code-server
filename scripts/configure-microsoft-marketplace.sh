#!/bin/bash

# Script để cấu hình code-server sử dụng Microsoft marketplace
echo "🛠️ Cấu hình code-server để sử dụng Microsoft marketplace..."

CONTAINER_NAME="vscode-selfhost"
COMPOSE_FILE="docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Backup docker-compose.yml
backup_compose() {
    if [ -f "$COMPOSE_FILE" ]; then
        cp "$COMPOSE_FILE" "${COMPOSE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Đã backup docker-compose.yml"
    fi
}

# Configure Microsoft marketplace using template
configure_microsoft_marketplace() {
    print_status "Cấu hình Microsoft marketplace..."

    # Check if docker-compose.yml exists
    if [ ! -f "$COMPOSE_FILE" ]; then
        print_error "Không tìm thấy file docker-compose.yml"
        exit 1
    fi

    # Use the Microsoft marketplace template
    if [ -f "docker-compose.microsoft-marketplace.yml" ]; then
        cp "docker-compose.microsoft-marketplace.yml" "$COMPOSE_FILE"
        print_success "Đã áp dụng cấu hình Microsoft marketplace"
    else
        print_error "Không tìm thấy template Microsoft marketplace"
        exit 1
    fi
}

# Restart container to apply changes
restart_container() {
    print_status "Khởi động lại container để áp dụng thay đổi..."

    if docker-compose ps | grep -q "$CONTAINER_NAME"; then
        docker-compose down
        sleep 2
        docker-compose up -d
        sleep 5
        print_success "Container đã được khởi động lại"
    else
        print_warning "Container không đang chạy. Hãy chạy ./scripts/start.sh để khởi động"
    fi
}

# Verify configuration
verify_configuration() {
    print_status "Kiểm tra cấu hình..."

    if docker ps | grep -q "$CONTAINER_NAME"; then
        # Check if Microsoft marketplace is configured
        if docker exec "$CONTAINER_NAME" env | grep -q "marketplace.visualstudio.com"; then
            print_success "Microsoft marketplace đã được cấu hình thành công"

            # Test extension installation
            print_status "Thử cài đặt extension test..."
            if docker exec "$CONTAINER_NAME" code-server --list-extensions > /dev/null 2>&1; then
                print_success "Extension marketplace hoạt động bình thường"
            else
                print_warning "Có thể có vấn đề với extension marketplace"
            fi
        else
            print_error "Cấu hình Microsoft marketplace thất bại"
            return 1
        fi
    else
        print_warning "Container không đang chạy. Không thể kiểm tra cấu hình"
    fi
}

# Show usage instructions
show_instructions() {
    echo ""
    echo "🎉 Cấu hình Microsoft marketplace hoàn tất!"
    echo "============================================"
    echo ""
    echo "📋 Thông tin quan trọng:"
    echo "• Microsoft marketplace hiện đã được kích hoạt"
    echo "• Bạn có thể cài đặt extensions từ Visual Studio Marketplace"
    echo "• GitHub Copilot và các extensions Microsoft khác sẽ hoạt động"
    echo ""
    echo "🚀 Cách sử dụng:"
    echo "1. Truy cập VSCode tại: http://localhost:8008"
    echo "2. Mở Extensions view (Ctrl+Shift+X)"
    echo "3. Tìm kiếm và cài đặt extensions từ Microsoft marketplace"
    echo ""
    echo "🔧 Cài đặt GitHub Copilot:"
    echo "• Chạy: ./scripts/install-copilot.sh"
    echo "• Hoặc: ./scripts/install-copilot-manual.sh"
    echo ""
    echo "⚠️  Lưu ý:"
    echo "• File docker-compose.yml đã được backup"
    echo "• Để quay lại OpenVSX, chạy: ./scripts/configure-openvsx-marketplace.sh"
    echo ""
}

# Main execution
main() {
    print_status "Bắt đầu cấu hình Microsoft marketplace..."

    backup_compose
    configure_microsoft_marketplace
    restart_container
    verify_configuration
    show_instructions

    print_success "Hoàn tất cấu hình Microsoft marketplace!"
}

# Run main function
main