```
echo denyinterfaces wlan0 | sudo tee -a /etc/dhcpcd.conf
sudo sed -i -e 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
```