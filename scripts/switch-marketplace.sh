#!/bin/bash

# Script để chuyển đổi nhanh giữa các marketplace
echo "🔄 Chuyển đổi Extension Marketplace cho VSCode Self-Host..."

CONTAINER_NAME="vscode-selfhost"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_header() {
    echo -e "${CYAN}$1${NC}"
}

# Backup current docker-compose.yml
backup_compose() {
    if [ -f "docker-compose.yml" ]; then
        cp "docker-compose.yml" "docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Đã backup docker-compose.yml"
    fi
}

# Switch to Microsoft marketplace
switch_to_microsoft() {
    print_status "Chuyển sang Microsoft Marketplace..."
    
    backup_compose
    
    if [ -f "docker-compose.microsoft-marketplace.yml" ]; then
        cp "docker-compose.microsoft-marketplace.yml" "docker-compose.yml"
        print_success "Đã chuyển sang Microsoft Marketplace"
        restart_container
        show_microsoft_info
    else
        print_error "Không tìm thấy template Microsoft marketplace"
        exit 1
    fi
}

# Switch to OpenVSX marketplace
switch_to_openvsx() {
    print_status "Chuyển sang OpenVSX Marketplace..."
    
    backup_compose
    
    if [ -f "docker-compose.openvsx-marketplace.yml" ]; then
        cp "docker-compose.openvsx-marketplace.yml" "docker-compose.yml"
        print_success "Đã chuyển sang OpenVSX Marketplace"
        restart_container
        show_openvsx_info
    else
        print_error "Không tìm thấy template OpenVSX marketplace"
        exit 1
    fi
}

# Restart container
restart_container() {
    print_status "Khởi động lại container..."
    
    # Stop container if running
    if docker ps | grep -q "$CONTAINER_NAME"; then
        docker-compose down
        sleep 2
    fi
    
    # Start container with new configuration
    docker-compose up -d
    sleep 5
    
    if docker ps | grep -q "$CONTAINER_NAME"; then
        print_success "Container đã được khởi động lại thành công"
    else
        print_error "Không thể khởi động container"
        exit 1
    fi
}

# Show Microsoft marketplace info
show_microsoft_info() {
    echo ""
    print_header "🏢 Microsoft Marketplace đã được kích hoạt!"
    echo "=========================================="
    echo ""
    echo "✅ Tính năng có sẵn:"
    echo "   • GitHub Copilot & Copilot Chat"
    echo "   • Microsoft Extensions (C#, Python, PowerShell, etc.)"
    echo "   • Tất cả extensions từ Visual Studio Marketplace"
    echo ""
    echo "🚀 Bước tiếp theo:"
    echo "   1. Truy cập: http://localhost:8008"
    echo "   2. Cài đặt GitHub Copilot: ./scripts/install-copilot.sh"
    echo "   3. Hoặc cài đặt thủ công: ./scripts/install-copilot-manual.sh"
    echo ""
}

# Show OpenVSX marketplace info
show_openvsx_info() {
    echo ""
    print_header "🌐 OpenVSX Marketplace đã được kích hoạt!"
    echo "========================================"
    echo ""
    echo "✅ Tính năng có sẵn:"
    echo "   • Open source extensions"
    echo "   • Không có license restrictions"
    echo "   • Tích hợp tốt với code-server"
    echo ""
    echo "⚠️  Lưu ý:"
    echo "   • GitHub Copilot không khả dụng trên OpenVSX"
    echo "   • Một số Microsoft extensions có thể không có"
    echo ""
    echo "🚀 Bước tiếp theo:"
    echo "   1. Truy cập: http://localhost:8008"
    echo "   2. Tìm kiếm extensions từ OpenVSX registry"
    echo ""
}

# Show current marketplace
check_current_marketplace() {
    if [ -f "docker-compose.yml" ]; then
        if grep -q "marketplace.visualstudio.com" "docker-compose.yml"; then
            print_success "Hiện tại: Microsoft Marketplace"
        elif grep -q "open-vsx.org" "docker-compose.yml"; then
            print_success "Hiện tại: OpenVSX Marketplace"
        else
            print_warning "Hiện tại: Cấu hình mặc định (có thể là OpenVSX)"
        fi
    else
        print_error "Không tìm thấy docker-compose.yml"
    fi
}

# Show usage
show_usage() {
    echo ""
    print_header "🛠️  Cách sử dụng:"
    echo "================"
    echo ""
    echo "$0 microsoft    # Chuyển sang Microsoft Marketplace"
    echo "$0 openvsx      # Chuyển sang OpenVSX Marketplace"
    echo "$0 status       # Kiểm tra marketplace hiện tại"
    echo "$0 help         # Hiển thị hướng dẫn này"
    echo ""
}

# Main execution
main() {
    case "${1:-}" in
        "microsoft")
            switch_to_microsoft
            ;;
        "openvsx")
            switch_to_openvsx
            ;;
        "status")
            print_status "Kiểm tra marketplace hiện tại..."
            check_current_marketplace
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        "")
            print_error "Vui lòng chỉ định marketplace"
            show_usage
            exit 1
            ;;
        *)
            print_error "Tùy chọn không hợp lệ: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
