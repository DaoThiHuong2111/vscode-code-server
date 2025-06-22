# Cấu hình Extension Marketplace cho VSCode Self-Host

## Tổng quan

VSCode Self-Host hỗ trợ hai loại extension marketplace chính:

1. **Microsoft Marketplace** (Visual Studio Marketplace) - Khuyến nghị cho GitHub Copilot
2. **OpenVSX Marketplace** - Mặc định của code-server

## So sánh Marketplace

### 🏢 Microsoft Marketplace
- ✅ **GitHub Copilot & Copilot Chat**
- ✅ **Microsoft Extensions** (C#, Python, PowerShell, etc.)
- ✅ **Nhiều extensions chất lượng cao**
- ✅ **Cập nhật thường xuyên**
- ❌ Một số extensions có thể có license restrictions

### 🌐 OpenVSX Marketplace
- ✅ **Open source và miễn phí**
- ✅ **Không có license restrictions**
- ✅ **Tích hợp tốt với code-server**
- ❌ Ít extensions hơn Microsoft Marketplace
- ❌ **Không có GitHub Copilot**

## Cách cấu hình

### Phương pháp 1: Sử dụng Script tự động (Khuyến nghị)

#### Chuyển sang Microsoft Marketplace:
```bash
./scripts/switch-marketplace.sh microsoft
```

#### Chuyển sang OpenVSX Marketplace:
```bash
./scripts/switch-marketplace.sh openvsx
```

#### Kiểm tra marketplace hiện tại:
```bash
./scripts/switch-marketplace.sh status
```

### Phương pháp 2: Sử dụng Marketplace Manager

```bash
./scripts/marketplace-manager.sh
```

Menu tương tác sẽ hiển thị với các tùy chọn:
1. Kiểm tra marketplace hiện tại
2. Chuyển sang Microsoft Marketplace
3. Chuyển sang OpenVSX Marketplace
4. So sánh các marketplace
5. Cài đặt GitHub Copilot
6. Kiểm tra extensions đã cài đặt
7. Troubleshoot marketplace issues

### Phương pháp 3: Cấu hình thủ công

#### Cấu hình Microsoft Marketplace:
```bash
./scripts/configure-microsoft-marketplace.sh
```

#### Cấu hình OpenVSX Marketplace:
```bash
./scripts/configure-openvsx-marketplace.sh
```

## Cài đặt GitHub Copilot

### Yêu cầu
- Phải sử dụng **Microsoft Marketplace**
- Cần có **GitHub Copilot subscription**

### Cách cài đặt

#### Phương pháp 1: Script tự động
```bash
./scripts/install-copilot.sh
```

#### Phương pháp 2: Cài đặt thủ công
```bash
./scripts/install-copilot-manual.sh
```

#### Phương pháp 3: Troubleshooting
```bash
./scripts/troubleshoot-copilot.sh
```

## Cấu hình kỹ thuật

### Biến môi trường cho Microsoft Marketplace:
```bash
EXTENSIONS_GALLERY='{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items", "controlUrl": "", "recommendationsUrl": ""}'
SERVICE_URL=https://marketplace.visualstudio.com/_apis/public/gallery
ITEM_URL=https://marketplace.visualstudio.com/items
```

### Biến môi trường cho OpenVSX Marketplace:
```bash
EXTENSIONS_GALLERY='{"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "controlUrl": "", "recommendationsUrl": ""}'
SERVICE_URL=https://open-vsx.org/vscode/gallery
ITEM_URL=https://open-vsx.org/vscode/item
```

## Troubleshooting

### Vấn đề thường gặp:

1. **Extensions không tải được:**
   - Kiểm tra kết nối internet
   - Chạy: `./scripts/troubleshoot-copilot.sh`

2. **GitHub Copilot không hoạt động:**
   - Đảm bảo đang sử dụng Microsoft Marketplace
   - Kiểm tra subscription GitHub Copilot
   - Thử cài đặt lại: `./scripts/install-copilot-manual.sh`

3. **Container không khởi động:**
   - Kiểm tra Docker daemon
   - Chạy: `docker-compose logs`

### Lệnh kiểm tra:

```bash
# Kiểm tra container
docker ps | grep vscode-selfhost

# Kiểm tra extensions đã cài đặt
docker exec vscode-selfhost code-server --list-extensions

# Kiểm tra biến môi trường
docker exec vscode-selfhost env | grep EXTENSIONS_GALLERY
```

## Files quan trọng

- `docker-compose.yml` - Cấu hình chính
- `docker-compose.microsoft-marketplace.yml` - Template Microsoft Marketplace
- `docker-compose.openvsx-marketplace.yml` - Template OpenVSX Marketplace
- `scripts/marketplace-manager.sh` - Tool quản lý marketplace
- `scripts/switch-marketplace.sh` - Tool chuyển đổi nhanh

## Khuyến nghị

1. **Cho GitHub Copilot:** Sử dụng Microsoft Marketplace
2. **Cho development thông thường:** OpenVSX Marketplace đủ dùng
3. **Backup:** Luôn backup docker-compose.yml trước khi thay đổi
4. **Testing:** Test extensions sau khi chuyển đổi marketplace

## Liên kết hữu ích

- [Visual Studio Marketplace](https://marketplace.visualstudio.com/)
- [OpenVSX Registry](https://open-vsx.org/)
- [GitHub Copilot](https://github.com/features/copilot)
- [code-server Documentation](https://coder.com/docs/code-server)
