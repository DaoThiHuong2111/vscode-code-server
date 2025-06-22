# VSCode Self-Host với Code-Server

Dự án này giúp bạn self-host VSCode trên Ubuntu bằng Docker và code-server, hỗ trợ Microsoft marketplace và các extension như GitHub Copilot.

## 🎯 Mục đích

- Self-host VSCode trên Ubuntu bằng code-server sử dụng Docker
- Sử dụng Docker để dễ quản lý
- Hỗ trợ Microsoft marketplace để cài đặt extension
- Có thể cài đặt các extension như GitHub Copilot

## 📋 Yêu cầu hệ thống

- Ubuntu 18.04+ (hoặc bất kỳ Linux distro nào hỗ trợ Docker)
- Docker và Docker Compose đã được cài đặt
- Port 8080 available (có thể thay đổi)

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
```
PASSWORD=your_secure_password_here
SUDO_PASSWORD=your_sudo_password_here
PROXY_DOMAIN=localhost
```

### Bước 3: Khởi động VSCode Self-Host

```bash
# Sử dụng script tự động
./scripts/start.sh

# Hoặc khởi động thủ công
docker-compose up -d
```

### Bước 4: Truy cập VSCode

Mở trình duyệt và truy cập: `http://localhost:8080`

Nhập password đã cấu hình trong file `.env`

## 📦 Cài đặt Extensions

### Cách 1: Sử dụng script tự động

```bash
./scripts/install-extensions.sh
```

### Cách 2: Cài đặt thủ công

1. Truy cập VSCode tại `http://localhost:8080`
2. Mở Extensions tab (Ctrl+Shift+X)
3. Tìm kiếm và cài đặt extension mong muốn

### GitHub Copilot

1. Tìm kiếm "GitHub Copilot" trong Extensions
2. Cài đặt extension
3. Đăng nhập với tài khoản GitHub của bạn
4. Kích hoạt Copilot subscription nếu chưa có

## 🛠️ Quản lý

### Dừng service

```bash
./scripts/stop.sh
# hoặc
docker-compose down
```

### Xem logs

```bash
docker-compose logs -f
```

### Restart service

```bash
docker-compose restart
```

## 📁 Cấu trúc thư mục

```
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment variables template
├── config/                # VSCode configuration files
├── data/                  # Workspace data
├── extensions/            # Installed extensions
└── scripts/
    ├── start.sh          # Start script
    ├── stop.sh           # Stop script
    └── install-extensions.sh  # Extensions installer
```

## 🔧 Tùy chỉnh

### Thay đổi port

Chỉnh sửa file `docker-compose.yml`:
```yaml
ports:
  - "9000:8080"  # Thay đổi port từ 8080 sang 9000
```

### Thêm volume mount

```yaml
volumes:
  - ./your-project:/home/coder/workspace/your-project
```

## 🐛 Troubleshooting

### Container không khởi động được

```bash
# Kiểm tra logs
docker-compose logs

# Kiểm tra permissions
sudo chown -R 1000:1000 config data extensions
```

### Không thể truy cập qua browser

1. Kiểm tra container có đang chạy không: `docker-compose ps`
2. Kiểm tra port có bị conflict không: `netstat -tulpn | grep 8080`
3. Kiểm tra firewall settings

### Extensions không cài được

1. Đảm bảo container đang chạy
2. Thử cài đặt thủ công qua VSCode interface
3. Kiểm tra network connection

## 📝 Ghi chú

- Data và configuration được persist trong các thư mục `config/`, `data/`, và `extensions/`
- Container chạy với user ID 1000 để tránh permission issues
- Hỗ trợ đầy đủ Microsoft marketplace
- Có thể truy cập Docker socket để build và run containers từ trong VSCode
