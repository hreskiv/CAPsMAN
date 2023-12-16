# Description

This repository contains two configuration files, each featuring configurations for two wireless networks named **VIP** and **Guest**. These configurations apply regardless of whether the device is in standalone or controller mode.

1. **capsman-standalone-hap-ac2**: 
   - Configuration for a standalone access point and CAPsMAN.
   - Includes the new wifi package from MikroTik.
   - Compatible with hAP AC^2, cAP AC or similar on RouterOS version 7.13 and higher.

2. **cap-ac-lte6**:
   - CAP configuration for the wAP AC LTE6 kit.
   - Includes working VLANs.

Both configurations support the following wireless networks:
- **VIP**: A secured network intended for privileged access.
- **Guest**: A network designed for guest users, offering limited access.
