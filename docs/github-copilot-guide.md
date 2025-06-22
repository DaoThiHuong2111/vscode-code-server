# GitHub Copilot Setup Guide for VSCode Self-Host

Hướng dẫn chi tiết để cài đặt và sử dụng GitHub Copilot trong VSCode self-host với code-server.

## 🎯 Tổng quan

GitHub Copilot là AI coding assistant của GitHub giúp bạn viết code nhanh hơn và hiệu quả hơn. Tài liệu này hướng dẫn cách enable Copilot trong môi trường code-server.

## 📋 Yêu cầu

- GitHub account với Copilot subscription active
- VSCode self-host đã được setup (theo README chính)
- Docker và Docker Compose đang chạy
- Internet connection để authentication

## 🚀 Cài đặt nhanh

### Phương pháp 1: Sử dụng script tự động (Khuyến nghị)

```bash
# Chạy script setup tự động
./scripts/setup-copilot.sh
```

Script này sẽ:
- Kiểm tra container đang chạy
- Cài đặt GitHub Copilot và Copilot Chat extensions
- Cấu hình settings cho Copilot
- Restart container
- Hiển thị hướng dẫn authentication

### Phương pháp 2: Cài đặt thủ công

```bash
# Cài đặt extensions
./scripts/install-copilot.sh

# Restart container
docker-compose restart
```

## 🔐 Authentication

### Bước 1: Truy cập VSCode
Mở trình duyệt và truy cập: `http://localhost:8080`

### Bước 2: Authenticate GitHub Copilot

#### Phương pháp A: Qua Status Bar (Dễ nhất)
1. Tìm icon GitHub Copilot ở status bar (góc dưới phải)
2. Click vào icon
3. Chọn "Sign in to GitHub"
4. Làm theo hướng dẫn authentication

#### Phương pháp B: Qua Command Palette
1. Mở Command Palette (`Ctrl+Shift+P` hoặc `Cmd+Shift+P`)
2. Gõ: `GitHub Copilot: Sign In`
3. Nhấn Enter và làm theo hướng dẫn

#### Phương pháp C: Qua Extensions View
1. Mở Extensions view (`Ctrl+Shift+X`)
2. Tìm "GitHub Copilot" trong danh sách installed
3. Click "Sign in" button

### Bước 3: Hoàn tất Authentication
1. Browser sẽ mở trang GitHub authentication
2. Đăng nhập GitHub account của bạn
3. Authorize GitHub Copilot
4. Copy authorization code nếu được yêu cầu
5. Paste vào VSCode khi được prompt

## ⚙️ Cấu hình

### Settings mặc định
Script setup đã tự động cấu hình:

```json
{
    "github.copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true
    },
    "github.copilot.inlineSuggest.enable": true,
    "github.copilot.chat.enabled": true
}
```

### Tùy chỉnh settings
Để thay đổi cấu hình, vào `File > Preferences > Settings` và tìm "GitHub Copilot".

## 🎮 Sử dụng GitHub Copilot

### Inline Suggestions
- Gõ code bình thường, Copilot sẽ suggest
- Nhấn `Tab` để accept suggestion
- Nhấn `Esc` để dismiss suggestion
- `Alt+]` để xem suggestion tiếp theo
- `Alt+[` để xem suggestion trước đó

### Copilot Chat
- Mở chat panel: `Ctrl+Shift+I`
- Hoặc Command Palette: `GitHub Copilot: Open Chat`
- Hỏi questions về code
- Request code generation
- Ask for explanations

### Keyboard Shortcuts
- `Ctrl+I`: Inline chat
- `Ctrl+Shift+I`: Open chat panel
- `Alt+\`: Toggle suggestions
- `Ctrl+Enter`: Open suggestions in new tab

## 🐛 Troubleshooting

### Copilot không hiển thị suggestions

**Giải pháp:**
1. Kiểm tra authentication status
2. Restart VSCode: `Ctrl+Shift+P` → `Developer: Reload Window`
3. Kiểm tra settings: `github.copilot.enable`

### Authentication thất bại

**Giải pháp:**
1. Clear browser cache
2. Thử incognito/private mode
3. Kiểm tra GitHub Copilot subscription
4. Restart container: `docker-compose restart`

### Extension không load

**Giải pháp:**
1. Kiểm tra container logs: `docker-compose logs`
2. Reinstall extensions:
   ```bash
   ./scripts/setup-copilot.sh
   ```
3. Kiểm tra permissions:
   ```bash
   sudo chown -R 1000:1000 extensions/
   ```

### "User not authorized" error

**Giải pháp:**
1. Đảm bảo có GitHub Copilot subscription
2. Check subscription tại: https://github.com/settings/copilot
3. Re-authenticate trong VSCode

## 📊 Kiểm tra trạng thái

### Kiểm tra extensions đã cài
```bash
docker exec vscode-selfhost code-server --list-extensions | grep copilot
```

### Kiểm tra authentication
1. Mở VSCode
2. Command Palette → `GitHub Copilot: Check Status`
3. Xem output trong Developer Console

## 🔄 Cập nhật

### Cập nhật Copilot extensions
```bash
# Cập nhật tất cả extensions
docker exec vscode-selfhost code-server --update-extensions

# Hoặc chạy lại setup script
./scripts/setup-copilot.sh
```

## 📝 Ghi chú quan trọng

- GitHub Copilot yêu cầu subscription trả phí
- Cần internet connection để hoạt động
- Data được gửi đến GitHub servers để processing
- Tuân thủ GitHub Copilot Terms of Service
- Không sử dụng cho sensitive/proprietary code nếu có policy hạn chế

## 🆘 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra logs: `docker-compose logs -f`
2. Restart container: `docker-compose restart`
3. Chạy lại setup: `./scripts/setup-copilot.sh`
4. Tham khảo GitHub Copilot documentation
