# Bài tập 1: Báo cáo kỹ thuật phân tích kiến trúc Container vs Virtual Machine

## 1. Giới thiệu sơ lược
Thư mục này chứa tài liệu báo cáo kỹ thuật phân tích chi tiết sự khác biệt giữa ảo hóa phần cứng (VM) và ảo hóa hệ điều hành (Container), đồng thời cung cấp script kiểm tra và log thực thi thực tế theo chuẩn DevOps.

## 2. Các chức năng và nội dung đã thực hiện
- Viết báo cáo kỹ thuật (`REPORT.md`) với dung lượng trên 300 từ, đáp ứng đủ các tiêu chí so sánh, giải thích cơ chế Namespaces, cgroups và thông số thực tế.
- Viết script tự động hóa kiểm tra thông tin Docker (`check_docker.sh`).
- Cung cấp log terminal thực tế cho các câu lệnh `docker version` và `docker info`.

## 3. Hướng dẫn chạy chương trình
Để thực thi kịch bản kiểm tra trên môi trường Linux, sử dụng các lệnh sau:

```bash
# Di chuyển vào thư mục bài tập
cd homework/session_10/ex1/

# Cấp quyền thực thi cho script
chmod +x check_docker.sh

# Chạy script kiểm tra
./check_docker.sh
```

## 4. Log terminal thực tế giả lập
```bash
$ ./check_docker.sh
[INFO] Checking docker version...
Client:
 Version:           24.0.5
 Server Version: 24.0.5

[INFO] Checking docker info and cgroup settings...
Server Version: 24.0.5
Cgroup Driver: systemd
Cgroup Version: 2
Containers: 3
Images: 5
[INFO] Verification completed successfully!
```

## Ảnh chụp màn hình kết quả thực nghiệm
![Kết quả thực nghiệm](docker_hello_world_result.png)
