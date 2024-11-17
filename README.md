# weatherapp

A new Flutter project.

![Screenshot](/images/z6037964477812_2da76afcbf82cd6332ce1b5161eeec9a.jpg)
## Installation
- Git clone https://github.com/quantran88/weatherapp
- Chạy lệnh flutter clean 
- Chạy lệnh flutter pub get để add toàn bộ thư viện vào
- Thay thế api trong class WeatherRepository cho giống với api của bạn trên https://www.weatherapi.com
- Chạy lệnh flutter run -d chrome để khởi chạy web
- Nếu muốn deploy hosting:
- Chạy lệnh flutter buid web 
- Chạy lệnh npm install -g firebase-tools
- Chạy lệnh firebase experiments:enable webframeworks
- Chạy lệnh firebase init hosting:
+ Answer yes when asked if you want to use a web framework.
+ If you're in an empty directory, you'll be asked to choose your web framework. Choose Flutter Web.
+ Choose your hosting source directory; this could be an existing flutter app.
+ Select a region to host your files.
+ Choose whether to set up automatic builds and deploys with GitHub.
- Deploy the app to Firebase Hosting:
+ Chạy lệnh firebase deploy --only hosting
## Feature
+Tìm kiếm thời tiết theo thành phố hoặc quốc gia.
+Xem dự báo thời tiết hàng ngày.
+Lưu trữ lịch sử tìm kiếm.
+Giao diện đáp ứng với thiết kế hiện đại.
## Usage
+Mở ứng dụng trong trình duyệt.
+Nhập tên thành phố hoặc quốc gia vào thanh tìm kiếm.
+Bấm nút "Tìm kiếm" để xem thông tin thời tiết hiện tại và dự báo.
## Project structure
weatherapp/
│
├── lib/
│   ├── main.dart                        # Tệp chính khởi động ứng dụng
│   ├──ui/screens/                       # Các màn hình UI chính   
│   ├──ui/provider/                      # Quản lý việc lấy dữ liệu thời tiết và vị trí người dùng
│   └──data/weather_repository/          # Các dịch vụ gọi API
│
└── pubspec.yaml                         # Tệp cấu hình dự án và các gói phụ thuộc