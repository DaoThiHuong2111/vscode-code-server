#!/bin/bash

# Script để test cấu hình marketplace
echo "🧪 Test cấu hình Marketplace..."

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

# Test YAML syntax
test_yaml_syntax() {
    local file="$1"
    local name="$2"
    
    print_status "Kiểm tra cú pháp YAML cho $name..."
    
    if [ ! -f "$file" ]; then
        print_error "File $file không tồn tại"
        return 1
    fi
    
    # Test with docker-compose config
    if docker-compose -f "$file" config > /dev/null 2>&1; then
        print_success "$name: Cú pháp YAML hợp lệ"
        return 0
    else
        print_error "$name: Cú pháp YAML không hợp lệ"
        echo "Chi tiết lỗi:"
        docker-compose -f "$file" config 2>&1 | head -10
        return 1
    fi
}

# Test environment variables
test_environment_vars() {
    local file="$1"
    local name="$2"
    
    print_status "Kiểm tra biến môi trường trong $name..."
    
    # Extract environment variables
    local env_vars=$(docker-compose -f "$file" config 2>/dev/null | grep -A 20 "environment:" | grep "EXTENSIONS_GALLERY" || echo "")
    
    if [ -n "$env_vars" ]; then
        print_success "$name: Biến môi trường EXTENSIONS_GALLERY được tìm thấy"
        echo "   $env_vars"
        return 0
    else
        print_warning "$name: Không tìm thấy biến môi trường EXTENSIONS_GALLERY"
        return 1
    fi
}

# Main test function
main() {
    echo "🚀 Bắt đầu test cấu hình marketplace..."
    echo ""
    
    local all_passed=true
    
    # Test Microsoft marketplace template
    if test_yaml_syntax "docker-compose.microsoft-marketplace.yml" "Microsoft Marketplace"; then
        test_environment_vars "docker-compose.microsoft-marketplace.yml" "Microsoft Marketplace"
    else
        all_passed=false
    fi
    
    echo ""
    
    # Test OpenVSX marketplace template
    if test_yaml_syntax "docker-compose.openvsx-marketplace.yml" "OpenVSX Marketplace"; then
        test_environment_vars "docker-compose.openvsx-marketplace.yml" "OpenVSX Marketplace"
    else
        all_passed=false
    fi
    
    echo ""
    
    # Test current docker-compose.yml
    if [ -f "docker-compose.yml" ]; then
        if test_yaml_syntax "docker-compose.yml" "Current Configuration"; then
            test_environment_vars "docker-compose.yml" "Current Configuration"
        else
            all_passed=false
        fi
    else
        print_warning "File docker-compose.yml không tồn tại"
    fi
    
    echo ""
    echo "========================================"
    
    if [ "$all_passed" = true ]; then
        print_success "✅ Tất cả test đều PASS!"
        echo ""
        echo "🚀 Bạn có thể sử dụng các script sau:"
        echo "• ./scripts/switch-marketplace.sh microsoft"
        echo "• ./scripts/switch-marketplace.sh openvsx"
        echo "• ./scripts/marketplace-manager.sh"
    else
        print_error "❌ Một số test FAILED!"
        echo ""
        echo "🔧 Hãy kiểm tra lại cấu hình YAML"
    fi
}

# Run main function
main
