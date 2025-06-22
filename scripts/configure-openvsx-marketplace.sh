#!/bin/bash

# Script để cấu hình code-server sử dụng OpenVSX marketplace (mặc định)
echo "🔄 Cấu hình code-server để sử dụng OpenVSX marketplace..."

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

# Configure OpenVSX marketplace
configure_openvsx_marketplace() {
    print_status "Cấu hình OpenVSX marketplace..."
    
    # OpenVSX marketplace configuration
    OPENVSX_GALLERY='{
        "serviceUrl": "https://open-vsx.org/vscode/gallery",
        "itemUrl": "https://open-vsx.org/vscode/item",
        "controlUrl": "",
        "recommendationsUrl": ""
    }'
    
    # Check if docker-compose.yml exists
    if [ ! -f "$COMPOSE_FILE" ]; then
        print_error "Không tìm thấy file docker-compose.yml"
        exit 1
    fi
    
    print_success "Đã tạo cấu hình OpenVSX marketplace"
}

# Update docker-compose.yml
update_docker_compose() {
    print_status "Cập nhật docker-compose.yml..."
    
    # Remove Microsoft marketplace environment variables
    sed -i.bak '/EXTENSIONS_GALLERY.*marketplace\.visualstudio\.com/d' "$COMPOSE_FILE"
    sed -i.bak '/SERVICE_URL.*marketplace\.visualstudio\.com/d' "$COMPOSE_FILE"
    sed -i.bak '/ITEM_URL.*marketplace\.visualstudio\.com/d' "$COMPOSE_FILE"
    
    # Check if environment section exists
    if grep -q "environment:" "$COMPOSE_FILE"; then
        print_status "Thêm biến môi trường OpenVSX vào section environment hiện có..."
        
        # Add OpenVSX marketplace environment variables
        sed -i.bak '/environment:/a\
      - EXTENSIONS_GALLERY={"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "controlUrl": "", "recommendationsUrl": ""}\
      - SERVICE_URL=https://open-vsx.org/vscode/gallery\
      - ITEM_URL=https://open-vsx.org/vscode/item' "$COMPOSE_FILE"
    else
        print_status "Tạo section environment mới với OpenVSX..."
        
        # Add environment section with OpenVSX marketplace variables
        sed -i.bak '/services:/,/code-server:/{
            /code-server:/a\
    environment:\
      - EXTENSIONS_GALLERY={"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "controlUrl": "", "recommendationsUrl": ""}\
      - SERVICE_URL=https://open-vsx.org/vscode/gallery\
      - ITEM_URL=https://open-vsx.org/vscode/item
        }' "$COMPOSE_FILE"
    fi
    
    print_success "Đã cập nhật docker-compose.yml"
}

# Restart container to apply changes
restart_container() {
    print_status "Khởi động lại container để áp dụng thay đổi..."
    
    if docker-compose ps | grep -q "$CONTAINER_NAME"; then
        docker-compose restart
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
        # Check if OpenVSX marketplace is configured
        if docker exec "$CONTAINER_NAME" env | grep -q "open-vsx.org"; then
            print_success "OpenVSX marketplace đã được cấu hình thành công"
            
            # Test extension installation
            print_status "Thử cài đặt extension test..."
            if docker exec "$CONTAINER_NAME" code-server --list-extensions > /dev/null 2>&1; then
                print_success "Extension marketplace hoạt động bình thường"
            else
                print_warning "Có thể có vấn đề với extension marketplace"
            fi
        else
            print_error "Cấu hình OpenVSX marketplace thất bại"
            return 1
        fi
    else
        print_warning "Container không đang chạy. Không thể kiểm tra cấu hình"
    fi
}

# Show usage instructions
show_instructions() {
    echo ""
    echo "🔄 Cấu hình OpenVSX marketplace hoàn tất!"
    echo "========================================"
    echo ""
    echo "📋 Thông tin quan trọng:"
    echo "• OpenVSX marketplace hiện đã được kích hoạt"
    echo "• Đây là marketplace mặc định của code-server"
    echo "• Extensions sẽ được tải từ open-vsx.org"
    echo ""
    echo "🚀 Cách sử dụng:"
    echo "1. Truy cập VSCode tại: http://localhost:8080"
    echo "2. Mở Extensions view (Ctrl+Shift+X)"
    echo "3. Tìm kiếm và cài đặt extensions từ OpenVSX"
    echo ""
    echo "⚠️  Lưu ý về GitHub Copilot:"
    echo "• GitHub Copilot có thể không khả dụng trên OpenVSX"
    echo "• Để sử dụng Copilot, chuyển về Microsoft marketplace:"
    echo "  ./scripts/configure-microsoft-marketplace.sh"
    echo ""
    echo "🔧 Extensions khuyến nghị từ OpenVSX:"
    echo "• Python extensions"
    echo "• JavaScript/TypeScript extensions"
    echo "• Docker extensions"
    echo "• Git extensions"
    echo ""
    echo "⚠️  Lưu ý:"
    echo "• File docker-compose.yml đã được backup"
    echo "• Để quay lại Microsoft marketplace, chạy: ./scripts/configure-microsoft-marketplace.sh"
    echo ""
}

# Main execution
main() {
    print_status "Bắt đầu cấu hình OpenVSX marketplace..."
    
    backup_compose
    configure_openvsx_marketplace
    update_docker_compose
    restart_container
    verify_configuration
    show_instructions
    
    print_success "Hoàn tất cấu hình OpenVSX marketplace!"
}

# Run main function
main
