# VSCode Self-Host với Code-Server

Dự án này giúp bạn self-host VSCode trên Ubuntu bằng Docker và code-server, hỗ trợ Microsoft marketplace và các extension như GitHub Copilot.

## 🎯 Mục đích

- Self-host VSCode trên Ubuntu bằng code-server sử dụng Docker
- Sử dụng Docker để dễ quản lý
- Hỗ trợ Microsoft marketplace để cài đặt extension
- Có thể cài đặt các extension như GitHub Copilot

## ⚡ Quick Start

```bash
# 1. Clone và setup
git clone <repository-url>
cd vscode-selfhost-code-server
cp .env.example .env

# 2. Chỉnh sửa .env (set passwords + enable Copilot)
nano .env
# Set: ENABLE_COPILOT=true để tự động setup GitHub Copilot

# 3. Khởi động (tự động setup Copilot nếu enabled)
./scripts/start.sh

# 4. Truy cập VSCode
# http://localhost:8080
```

> 💡 **Tip:** Với `ENABLE_COPILOT=true`, GitHub Copilot sẽ được tự động setup khi start!

## 📋 Yêu cầu hệ thống

- Ubuntu 18.04+ (hoặc bất kỳ Linux distro nào hỗ trợ Docker)
- Docker và Docker Compose đã được cài đặt
- Port 8080 available (có thể thay đổi)
- 4GB+ RAM (khuyến nghị cho smooth experience)

## 🚀 Hướng dẫn cài đặt

### Bước 1: Clone repository

```bash
git clone <repository-url>
cd vscode-selfhost-code-server
```

### Bước 2: Cấu hình environment

```bash
# Copy file cấu hình mẫu
cp .env.example .env

# Chỉnh sửa file .env
nano .env
```

Thay đổi các giá trị trong file `.env`:
```env
PASSWORD=your_secure_password_here
SUDO_PASSWORD=your_sudo_password_here
PROXY_DOMAIN=localhost
ENABLE_COPILOT=true  # Bật hỗ trợ GitHub Copilot
```

### Bước 3: Khởi động VSCode Self-Host

```bash
# Sử dụng script tự động (Khuyến nghị)
./scripts/start.sh
# ✨ Tự động setup GitHub Copilot nếu ENABLE_COPILOT=true

# Hoặc khởi động thủ công
docker-compose up -d
```

### Bước 4: Truy cập VSCode

1. Mở trình duyệt và truy cập: `http://localhost:8080`
2. Nhập password đã cấu hình trong file `.env`
3. Chờ VSCode load hoàn tất

✅ **Hoàn tất!** Bạn đã có VSCode self-host sẵn sàng sử dụng.

## 📦 Cài đặt Extensions

### 🔧 Extensions cơ bản

Cài đặt các extensions phổ biến:

```bash
./scripts/install-extensions.sh
```

Extensions được cài đặt:
- Python
- TypeScript/JavaScript
- Prettier (Code formatter)
- ESLint
- Tailwind CSS
- Auto Rename Tag
- Live Server
- Git support

### 🎨 Cài đặt extensions khác

1. Truy cập VSCode tại `http://localhost:8080`
2. Mở Extensions tab (`Ctrl+Shift+X`)
3. Tìm kiếm và cài đặt extension mong muốn

## 🤖 GitHub Copilot (AI Coding Assistant)

> **Yêu cầu:** GitHub account với Copilot subscription active

### 🚀 Auto Setup (Khuyến nghị)

**Cách 1: Tự động khi start (Mới!)**
```bash
# Set trong .env
ENABLE_COPILOT=true

# Chạy start script - Copilot sẽ tự động được setup
./scripts/start.sh
```

**Cách 2: Manual setup**
```bash
./scripts/setup-copilot.sh
```

Script sẽ tự động:
- ✅ Cài đặt GitHub Copilot và Copilot Chat extensions
- ✅ Cấu hình settings tối ưu cho AI coding
- ✅ Restart container với cấu hình mới
- ✅ Hiển thị hướng dẫn authentication chi tiết

### 🔐 Authentication

1. **Truy cập VSCode:** `http://localhost:8080`
2. **Tìm Copilot icon** ở status bar (góc dưới phải)
3. **Click "Sign in to GitHub"** và làm theo hướng dẫn
4. **Hoặc dùng Command Palette:** `Ctrl+Shift+P` → `GitHub Copilot: Sign In`

### 🎯 Cách sử dụng

- **Inline suggestions:** Gõ code, Copilot sẽ suggest → Nhấn `Tab` để accept
- **Chat với AI:** `Ctrl+Shift+I` để mở chat panel
- **Inline chat:** `Ctrl+I` để chat ngay trong editor
- **Toggle suggestions:** `Alt+\` để bật/tắt suggestions

📖 **Hướng dẫn chi tiết:** [GitHub Copilot Guide](docs/github-copilot-guide.md)

## 🛠️ Quản lý và Sử dụng

### 🔄 Quản lý service

```bash
# Khởi động
./scripts/start.sh

# Dừng service
./scripts/stop.sh

# Restart service
docker-compose restart

# Xem logs
docker-compose logs -f

# Kiểm tra trạng thái
docker-compose ps
```

### 💡 Tips sử dụng

1. **Workspace:** Tất cả files trong thư mục `data/` sẽ được persist
2. **Extensions:** Được lưu trong thư mục `extensions/`
3. **Settings:** Cấu hình VSCode được lưu trong `config/`
4. **Docker access:** Có thể build và run containers từ trong VSCode
5. **Terminal:** Sử dụng integrated terminal như VSCode desktop

### 🔧 Customization

**Thay đổi port:**
```yaml
# docker-compose.yml
ports:
  - "9000:8080"  # Thay đổi từ 8080 sang 9000
```

**Mount project folder:**
```yaml
# docker-compose.yml
volumes:
  - ./your-project:/home/coder/workspace/your-project
```

## 📁 Cấu trúc thư mục

```
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment variables template
├── config/                # VSCode configuration files
├── data/                  # Workspace data
├── extensions/            # Installed extensions
├── docs/
│   └── github-copilot-guide.md  # GitHub Copilot detailed guide
└── scripts/
    ├── start.sh          # Start script
    ├── stop.sh           # Stop script
    ├── install-extensions.sh  # Extensions installer
    ├── install-copilot.sh     # GitHub Copilot installer
    └── setup-copilot.sh       # Complete Copilot setup
```



## 🐛 Troubleshooting

### ❌ Container không khởi động

```bash
# Kiểm tra logs chi tiết
docker-compose logs

# Fix permissions
sudo chown -R 1000:1000 config data extensions

# Restart clean
docker-compose down && docker-compose up -d
```

### 🌐 Không truy cập được VSCode

1. **Kiểm tra container:** `docker-compose ps`
2. **Kiểm tra port conflict:** `netstat -tulpn | grep 8080`
3. **Kiểm tra firewall:** Đảm bảo port 8080 không bị block
4. **Thử port khác:** Sửa `docker-compose.yml` → `"9000:8080"`

### 📦 Extensions không cài được

1. **Container running?** `docker-compose ps`
2. **Network OK?** Kiểm tra internet connection
3. **Manual install:** Qua VSCode Extensions tab
4. **Restart:** `docker-compose restart`

### 🤖 GitHub Copilot issues

| Vấn đề | Giải pháp |
|--------|-----------|
| Không authenticate được | 1. Kiểm tra subscription: https://github.com/settings/copilot<br>2. Clear browser cache<br>3. Thử incognito mode |
| Không có suggestions | 1. `./scripts/setup-copilot.sh`<br>2. Restart container<br>3. Check settings: `github.copilot.enable` |
| Extension không load | 1. Reinstall: `./scripts/setup-copilot.sh`<br>2. Check logs: `docker-compose logs`<br>3. Fix permissions |

📖 **Chi tiết:** [GitHub Copilot Troubleshooting Guide](docs/github-copilot-guide.md#troubleshooting)

## 📝 Ghi chú quan trọng

### 💾 Data Persistence
- **Workspace:** `data/` - Tất cả projects và files
- **Extensions:** `extensions/` - Installed extensions
- **Settings:** `config/` - VSCode configuration
- **Backup:** Backup các thư mục này để preserve setup

### 🔒 Security & Permissions
- Container chạy với user ID 1000 (non-root)
- Password authentication required
- Chỉ bind localhost (không expose ra internet)
- Docker socket access cho container builds

### 🌟 Features
- ✅ Full Microsoft marketplace support
- ✅ GitHub Copilot integration
- ✅ Docker-in-Docker support
- ✅ Integrated terminal
- ✅ Git integration
- ✅ Extensions persistence
- ✅ Settings sync ready

### 🚀 Performance Tips
- Allocate đủ RAM cho Docker (ít nhất 4GB)
- SSD storage cho better performance
- Stable internet cho Copilot và extensions

---

**🎉 Enjoy coding với VSCode self-host + GitHub Copilot!**

Có vấn đề? Tạo issue hoặc xem [troubleshooting guide](docs/github-copilot-guide.md) 📚
