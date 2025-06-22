#!/bin/bash

# Script quản lý marketplace cho code-server
echo "🛒 Quản lý Extension Marketplace cho VSCode Self-Host..."

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

# Check current marketplace configuration
check_current_marketplace() {
    print_status "Kiểm tra cấu hình marketplace hiện tại..."
    
    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        print_error "Container $CONTAINER_NAME không đang chạy"
        print_status "Hãy chạy ./scripts/start.sh để khởi động container"
        return 1
    fi
    
    # Check environment variables
    local extensions_gallery=$(docker exec "$CONTAINER_NAME" env | grep "EXTENSIONS_GALLERY" || echo "")
    local service_url=$(docker exec "$CONTAINER_NAME" env | grep "SERVICE_URL" || echo "")
    
    echo ""
    print_header "📊 Trạng thái Marketplace hiện tại:"
    echo "=================================="
    
    if [[ "$extensions_gallery" == *"marketplace.visualstudio.com"* ]]; then
        print_success "✅ Microsoft Marketplace (Visual Studio Marketplace)"
        echo "   🔗 URL: https://marketplace.visualstudio.com"
        echo "   🎯 Hỗ trợ: GitHub Copilot, Microsoft Extensions"
        return 0
    elif [[ "$extensions_gallery" == *"open-vsx.org"* ]]; then
        print_warning "🔄 OpenVSX Marketplace"
        echo "   🔗 URL: https://open-vsx.org"
        echo "   🎯 Hỗ trợ: Open Source Extensions"
        return 2
    else
        print_warning "❓ Marketplace chưa được cấu hình rõ ràng"
        echo "   📝 Sử dụng cấu hình mặc định của code-server"
        return 3
    fi
}

# Show marketplace comparison
show_marketplace_comparison() {
    echo ""
    print_header "📋 So sánh Marketplace:"
    echo "======================="
    echo ""
    echo "🏢 Microsoft Marketplace (Visual Studio Marketplace):"
    echo "   ✅ GitHub Copilot & Copilot Chat"
    echo "   ✅ Microsoft Extensions (C#, Python, etc.)"
    echo "   ✅ Nhiều extensions chất lượng cao"
    echo "   ✅ Cập nhật thường xuyên"
    echo "   ❌ Một số extensions có thể có license restrictions"
    echo ""
    echo "🌐 OpenVSX Marketplace:"
    echo "   ✅ Open source và miễn phí"
    echo "   ✅ Không có license restrictions"
    echo "   ✅ Tích hợp tốt với code-server"
    echo "   ❌ Ít extensions hơn Microsoft Marketplace"
    echo "   ❌ Không có GitHub Copilot"
    echo ""
}

# Show menu
show_menu() {
    echo ""
    print_header "🛠️  Tùy chọn quản lý Marketplace:"
    echo "================================="
    echo "1. Kiểm tra marketplace hiện tại"
    echo "2. Chuyển sang Microsoft Marketplace"
    echo "3. Chuyển sang OpenVSX Marketplace"
    echo "4. So sánh các marketplace"
    echo "5. Cài đặt GitHub Copilot (Microsoft Marketplace)"
    echo "6. Kiểm tra extensions đã cài đặt"
    echo "7. Troubleshoot marketplace issues"
    echo "8. Thoát"
    echo ""
    read -p "Chọn tùy chọn (1-8): " choice
    
    case $choice in
        1)
            check_current_marketplace
            ;;
        2)
            print_status "Chuyển sang Microsoft Marketplace..."
            ./scripts/configure-microsoft-marketplace.sh
            ;;
        3)
            print_status "Chuyển sang OpenVSX Marketplace..."
            ./scripts/configure-openvsx-marketplace.sh
            ;;
        4)
            show_marketplace_comparison
            ;;
        5)
            print_status "Cài đặt GitHub Copilot..."
            echo "Chọn phương pháp cài đặt:"
            echo "1. Cài đặt tự động (khuyến nghị)"
            echo "2. Cài đặt thủ công"
            echo "3. Troubleshoot installation"
            read -p "Chọn (1-3): " install_choice
            case $install_choice in
                1) ./scripts/install-copilot.sh ;;
                2) ./scripts/install-copilot-manual.sh ;;
                3) ./scripts/troubleshoot-copilot.sh ;;
                *) print_error "Lựa chọn không hợp lệ" ;;
            esac
            ;;
        6)
            print_status "Kiểm tra extensions đã cài đặt..."
            if docker ps | grep -q "$CONTAINER_NAME"; then
                echo ""
                print_header "📦 Extensions đã cài đặt:"
                docker exec "$CONTAINER_NAME" code-server --list-extensions
            else
                print_error "Container không đang chạy"
            fi
            ;;
        7)
            print_status "Chạy troubleshoot marketplace..."
            ./scripts/troubleshoot-copilot.sh
            ;;
        8)
            print_success "Tạm biệt!"
            exit 0
            ;;
        *)
            print_error "Lựa chọn không hợp lệ. Vui lòng chọn 1-8."
            ;;
    esac
}

# Show current status
show_status() {
    echo ""
    print_header "🚀 VSCode Self-Host Marketplace Manager"
    echo "======================================="
    
    # Check container status
    if docker ps | grep -q "$CONTAINER_NAME"; then
        print_success "Container đang chạy: http://localhost:8080"
    else
        print_warning "Container không đang chạy"
        print_status "Chạy ./scripts/start.sh để khởi động"
    fi
    
    # Check current marketplace
    check_current_marketplace
}

# Main execution
main() {
    show_status
    
    # Main menu loop
    while true; do
        show_menu
        echo ""
        read -p "Nhấn Enter để tiếp tục hoặc Ctrl+C để thoát..."
    done
}

# Run main function
main
