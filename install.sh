#!/bin/bash

# ==========================================
# UDP Custom Installer - ภาษาไทย
# Repository: https://github.com/benzvpn/UDP-Custom-TH
# ==========================================

# อัปเดตระบบ
apt update -y
apt upgrade -y

# ติดตั้งแพ็กเกจที่จำเป็น
apt install lolcat -y
apt install figlet -y
apt install neofetch -y
apt install screenfetch -y
apt install unzip -y
apt install wget -y

# กลับไปยัง /root
cd /root

# ลบโฟลเดอร์ UDP เดิม
rm -rf /root/udp

# สร้างโฟลเดอร์ UDP
mkdir -p /root/udp

# ==========================================
# แสดง Banner
# ==========================================

clear

echo -e "          ░█▀▀▄ ░█▀▀▀ ░█──░█ ▀▀▀░█ " | lolcat
echo -e "          ░█▄▄▀ ░█▀▀▀ ░█▄─░█ ─▄▀── " | lolcat
echo -e "          ░█─░█ ░█▄▄▄ ░█─▄▀█ ░█▄▄▄ " | lolcat

echo ""
echo ""
echo ""

sleep 5

# ==========================================
# ตั้งค่าโซนเวลา
# ==========================================

echo "กำลังตั้งค่าโซนเวลาเป็น GMT+5:30 (ศรีลังกา)..."

ln -fs /usr/share/zoneinfo/Asia/Colombo /etc/localtime

echo "ตั้งค่าโซนเวลาเรียบร้อยแล้ว"
echo ""

# ==========================================
# ดาวน์โหลด UDP Custom
# ==========================================

echo "กำลังดาวน์โหลด UDP Custom..." | lolcat

wget -q \
"https://github.com/benzvpn/UDP-Custom-TH/raw/main/udp-custom-linux-amd64" \
-O /root/udp/udp-custom

if [ ! -f /root/udp/udp-custom ]; then
    echo "ไม่สามารถดาวน์โหลด UDP Custom ได้!"
    exit 1
fi

chmod +x /root/udp/udp-custom

echo "ดาวน์โหลด UDP Custom สำเร็จ"
echo ""

# ==========================================
# ดาวน์โหลดไฟล์ Config
# ==========================================

echo "กำลังดาวน์โหลดไฟล์ตั้งค่าเริ่มต้น..." | lolcat

wget -q \
"https://raw.githubusercontent.com/benzvpn/UDP-Custom-TH/main/config.json" \
-O /root/udp/config.json

if [ ! -f /root/udp/config.json ]; then
    echo "ไม่สามารถดาวน์โหลด config.json ได้!"
    exit 1
fi

chmod 644 /root/udp/config.json

echo "ดาวน์โหลด config.json สำเร็จ"
echo ""

# ==========================================
# สร้าง Systemd Service
# ==========================================

echo "กำลังสร้างบริการ udp-custom..." | lolcat

if [ -z "$1" ]; then

cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom - BenzVPN
After=network.target

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
EOF

else

cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom - BenzVPN
After=network.target

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=multi-user.target
EOF

fi

echo "สร้างบริการ udp-custom เรียบร้อยแล้ว"
echo ""

# ==========================================
# ติดตั้ง UDP Custom Manager
# ==========================================

clear

echo "==========================================" | lolcat
echo "       ติดตั้ง UDP Custom Manager" | lolcat
echo "==========================================" | lolcat

echo ""
echo "กำลังเตรียมระบบจัดการผู้ใช้งาน..."
echo ""

sleep 5

# ==========================================
# สร้างโฟลเดอร์ Sslablk
# ==========================================

cd "$HOME"

mkdir -p /etc/Sslablk

cd /etc/Sslablk

# ==========================================
# ดาวน์โหลดระบบจัดการ
# ==========================================

echo "กำลังดาวน์โหลดระบบจัดการ UDP Custom..." | lolcat

wget -q \
"https://github.com/benzvpn/UDP-Custom-TH/raw/main/system.zip" \
-O /etc/Sslablk/system.zip

if [ ! -f /etc/Sslablk/system.zip ]; then
    echo "ไม่สามารถดาวน์โหลด system.zip ได้!"
    exit 1
fi

# ==========================================
# แตกไฟล์ระบบจัดการ
# ==========================================

echo "กำลังติดตั้งระบบจัดการ..." | lolcat

unzip -o /etc/Sslablk/system.zip -d /etc/Sslablk/

if [ ! -d /etc/Sslablk/system ]; then
    echo "ไม่พบโฟลเดอร์ system หลังจากแตกไฟล์!"
    exit 1
fi

cd /etc/Sslablk/system

# ==========================================
# กำหนดสิทธิ์ไฟล์
# ==========================================

chmod +x ChangeUser.sh
chmod +x Adduser.sh
chmod +x DelUser.sh
chmod +x Userlist.sh
chmod +x RemoveScript.sh
chmod +x torrent.sh

# ==========================================
# ติดตั้งคำสั่ง menu
# ==========================================

if [ -f /etc/Sslablk/system/menu ]; then

    mv -f /etc/Sslablk/system/menu /usr/local/bin/menu

    chmod +x /usr/local/bin/menu

else

    echo "ไม่พบไฟล์ menu!"
    exit 1
fi

# ==========================================
# ลบไฟล์ ZIP
# ==========================================

cd /etc/Sslablk

rm -f system.zip

# ==========================================
# โหลด Systemd
# ==========================================

systemctl daemon-reload

# ==========================================
# แสดงข้อความติดตั้งเสร็จ
# ==========================================

clear

echo "==========================================" | lolcat
echo "       ติดตั้ง UDP Custom สำเร็จ" | lolcat
echo "==========================================" | lolcat

echo ""
echo "UDP Custom ติดตั้งเรียบร้อยแล้ว"
echo ""
echo "ผู้พัฒนา : BenzVPN / UDP Custom TH"
echo "GitHub   : benzvpn/UDP-Custom-TH"
echo ""
echo "คำสั่งจัดการระบบ : menu"
echo ""

sleep 3

# ==========================================
# เริ่มบริการ UDP Custom
# ==========================================

echo "กำลังเริ่มบริการ UDP Custom..." | lolcat

systemctl start udp-custom

if systemctl is-active --quiet udp-custom; then
    echo "UDP Custom เริ่มทำงานเรียบร้อยแล้ว" | lolcat
else
    echo "ไม่สามารถเริ่ม UDP Custom ได้"
    echo ""
    echo "ตรวจสอบสถานะด้วยคำสั่ง:"
    echo "systemctl status udp-custom"
    echo ""
fi

# ==========================================
# เปิดให้เริ่มอัตโนมัติเมื่อเปิดเครื่อง
# ==========================================

echo "กำลังตั้งค่าให้ UDP Custom เริ่มอัตโนมัติ..." | lolcat

systemctl enable udp-custom

echo ""
echo "==========================================" | lolcat
echo "           ติดตั้งเสร็จสมบูรณ์" | lolcat
echo "==========================================" | lolcat
echo ""
echo "คำสั่งเปิดเมนูจัดการ:"
echo ""
echo "menu"
echo ""
echo "ตรวจสอบสถานะ:"
echo ""
echo "systemctl status udp-custom"
echo ""
echo "==========================================" | lolcat

sleep 5

# ==========================================
# รีบูตเซิร์ฟเวอร์
# ==========================================

echo ""
echo "ระบบจะรีบูตเซิร์ฟเวอร์ในอีก 5 วินาที..." | lolcat
echo ""

sleep 5

reboot