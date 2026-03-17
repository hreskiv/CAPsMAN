# MikroTik CAPsMAN — Dual SSID with VLANs

![RouterOS](https://img.shields.io/badge/RouterOS-7.13%2B-blue)
![License](https://img.shields.io/github/license/hreskiv/CAPsMAN)
![Stars](https://img.shields.io/github/stars/hreskiv/CAPsMAN)

Ready-to-use RouterOS v7 configurations for a **dual-SSID wireless setup** (VIP + Guest) with VLAN isolation, using the new `wifi` package (WifiWave2/CAPsMAN v2).

## Network Design

| Network | SSID | VLAN | Purpose |
|---------|------|------|---------|
| **VIP** | wifi6-vip | 10 | Secured, full access |
| **Guest** | wifi6-guest | 20 | Limited access, client isolation |
| **Management** | — | 33 | AP management |

### Security

- WPA2-PSK + WPA3-PSK (both networks)
- 802.11r Fast Transition (FT over DS)
- WPS disabled
- Client isolation on Guest network

## Configurations

### 1. `capsman-standalone-hap-ac2.rsc` — Controller / Standalone AP

Full CAPsMAN controller configuration that also serves as a standalone access point.

- **Device:** hAP AC², cAP AC, or similar dual-band
- **Mode:** Standalone AP + CAPsMAN controller
- **Bands:** 2.4 GHz (20 MHz) + 5 GHz (20/40 MHz, DFS skipped)
- **Country:** Poland

Includes: bridge, VLANs, wifi channels, datapaths, security profiles, and CAPsMAN provisioning.

### 2. `cap-ac-lte6.rsc` — Managed CAP

Controlled Access Point configuration for devices managed by the controller above.

- **Device:** wAP AC LTE6 kit
- **Mode:** CAP (managed by CAPsMAN)
- **VLANs:** Fully functional — traffic tagged and forwarded to controller via trunk

## Quick Start

1. Set up the **controller** first:
   ```
   /import file-name=capsman-standalone-hap-ac2.rsc
   ```

2. Then configure each **CAP**:
   ```
   /import file-name=cap-ac-lte6.rsc
   ```

3. Adjust SSIDs, passphrases, and VLAN IDs to match your environment.

> **Note:** Review and edit the scripts before importing — they contain example values. At minimum, set your wireless passphrases in the security profiles.

## Requirements

- RouterOS **7.13** or higher
- The `wifi` package (replaces the legacy `wireless` and `capsman` packages)
- Dual-band hardware (2.4 + 5 GHz)

## Topology

```
         ┌─────────────┐
         │   Router     │
         │  (gateway)   │
         └──────┬───────┘
                │ trunk (VLAN 10, 20, 33)
         ┌──────┴───────┐
         │  hAP AC²     │
         │  CAPsMAN +   │
         │  Standalone AP│
         └──────┬───────┘
                │ trunk
         ┌──────┴───────┐
         │  wAP AC LTE6 │
         │  (CAP)       │
         └──────────────┘
```

## Related

- [MikroTik WiFi Documentation](https://help.mikrotik.com/docs/spaces/ROS/pages/328227/WiFi)
- [CAPsMAN v2 Guide](https://help.mikrotik.com/docs/spaces/ROS/pages/328227/WiFi#WiFi-CAPsMAN)

## Author

**Ihor Hreskiv** — MikroTik Certified Trainer

- [mtik.pl](https://mtik.pl) — MikroTik training (Poland, Kraków)
- [mtik.tech](https://mtik.tech) — MikroTik training (Ukraine, online)
- [YouTube PL](https://www.youtube.com/@mikrotikpolska) · [YouTube UA](https://www.youtube.com/@mikrotikukraine)
- [LinkedIn](https://www.linkedin.com/in/hreskiv) · [GitHub](https://github.com/hreskiv)
