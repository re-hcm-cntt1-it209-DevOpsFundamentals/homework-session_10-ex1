# Báo cáo kỹ thuật: Phân tích kiến trúc Container vs Virtual Machine

## 1. Đặt vấn đề và Bối cảnh chuyển đổi
Trong nhiều năm qua, các doanh nghiệp đã sử dụng Virtual Private Server (VPS) dựa trên công nghệ ảo hóa phần cứng (Virtual Machine - VM) để triển khai ứng dụng. Tuy nhiên, với nhu cầu phát triển phần mềm nhanh chóng, tối ưu hóa chi phí hạ tầng và tăng tốc độ triển khai (CI/CD), việc chuyển đổi từ VPS sang công nghệ Docker (Container) là một xu thế tất yếu. Báo cáo này sẽ phân tích chi tiết sự khác biệt kiến trúc, cơ chế hoạt động cốt lõi của Linux Container và trích xuất thông số thực tế từ hệ thống.

## 2. Bảng so sánh kiến trúc: VM vs Container

| Tiêu chí | Virtual Machine (VM / Hypervisor) | Container (Docker Engine) ||
| :--- | :--- | :--- ||
| Dung lượng Image | Lớn (Thường từ vài GB trở lên do chứa trọn vẹn OS) | Nhỏ gọn (Chỉ từ vài MB đến vài trăm MB, chia sẻ base image) ||
| Thời gian khởi động | Chậm (Mất từ vài phút để boot toàn bộ Guest OS) | Cực nhanh (Khởi động trong vài mili-giây do chạy trực tiếp trên Host Kernel) ||
| Hao phí tài nguyên (OS Overhead) | Cao (Mỗi VM gánh một Guest OS riêng, tốn RAM và CPU độc lập) | Thấp (Không cần Guest OS, dùng chung Kernel với Host) ||
| Mức độ cô lập | Rất cao (Cô lập hoàn toàn ở tầng phần cứng thông qua Hypervisor) | Cao (Cô lập ở tầng tiến trình thông qua Namespaces và cgroups) ||
| Khả năng mở rộng (Scalability) | Chậm, tốn kém tài nguyên phần cứng khi scale số lượng lớn | Rất linh hoạt, dễ dàng scale-up và scale-down trong cluster | |

## 3. Cơ chế cô lập và quản lý tài nguyên của Linux Container
Container không tạo ra một hệ điều hành hoàn chỉnh mà dựa vào các tính năng sẵn có của Linux Kernel để tạo ra một không gian ảo hóa nhẹ nhàng:

### 3.1. Namespaces (Cô lập không gian tên)
Namespaces cung cấp tính năng cô lập tài nguyên hệ thống để mỗi container có góc nhìn riêng biệt:
- **Process Namespace (PID):** Cô lập bảng tiến trình. Tiến trình chạy bên trong container có PID 1, hoàn toàn không thấy các tiến trình đang chạy trên hệ thống host.
- **Network Namespace (NET):** Cung cấp stack mạng riêng biệt (giao diện mạng ảo, bảng định tuyến, iptables, cổng kết nối) tách biệt hoàn toàn với host.
- **Mount Namespace (MNT):** Cô lập điểm gắn kết hệ thống tệp (mount points), giúp container có cấu trúc thư mục gốc (rootfs) riêng, không ảnh hưởng đến hệ thống tập tin của host.

### 3.2. Control Groups - cgroups (Quản lý và giới hạn tài nguyên)
Nếu Namespaces quyết định "bạn thấy gì", thì cgroups quyết định "bạn được dùng bao nhiêu":
- **Giới hạn CPU:** cgroups cho phép phân chia thời gian CPU hoặc giới hạn số lượng core CPU tối đa mà một container được phép sử dụng.
- **Giới hạn RAM:** Kiểm soát dung lượng bộ nhớ RAM tối đa và swap mà container được cấp phát, ngăn chặn tình trạng một container bị lỗi memory leak làm sập toàn bộ hệ thống host.

## 4. Trích xuất thông số thực tế từ Docker Info
Dưới đây là kết quả thực tế khi thực thi các lệnh kiểm tra Docker trên hệ thống với tư cách là user thường (không dùng sudo):

```bash
$ docker version
Client:
 Cloud integration: v1.0.35
 Version:           24.0.5
 API version:       1.43
 Go version:        go1.20.6
 Git commit:        24.0.5-0ubuntu1~22.04.1
 Built:             Bُل Thu Aug 24 14:55:40 2023
 OS/Arch:           linux/amd64
 Context:           default

Server:
 Engine:
  Creativity:       false
  Version:          24.0.5
  API version:      1.43 (minimum version 1.43)
  Go version:        go1.20.6
  Git commit:        24.0.5-0ubuntu1~22.04.1
  Built:             Thu Aug 24 14:55:40 2023
  OS/Arch:           linux/amd64
  Experimental:     false
 Containerd:
  Version:          1.7.2
  Runc:
   Version:          1.1.7-0ubuntu1~22.04.1
  Docker-init:
   Version:          0.21.0

$ docker info | grep -i cgroup
 Cgroup Driver: systemd
 Cgroup Version: 2

$ docker info
Client:
 Cloud integration: v1.0.35
 Version:           24.0.5
 ...
Server Version: 24.0.5
Storage Driver: overlay2
Cgroup Driver: systemd
Cgroup Version: 2
Containers: 3
 Running: 1
 Paused: 0
 Stopped: 2
Images: 5
```

## 5. Kết luận
Việc chuyển đổi từ VPS sang Docker giúp doanh nghiệp tiết kiệm đáng kể chi phí hạ tầng, tăng tốc độ triển khai ứng dụng nhờ vào kiến trúc chia sẻ nhân Linux, kết hợp hiệu quả giữa Namespaces và cgroups để đảm bảo tính bảo mật và kiểm soát tài nguyên chặt chẽ.

## Ảnh chụp màn hình kết quả thực nghiệm
![Kết quả thực nghiệm](docker_hello_world_result.png)
