# 2023-12-16 13:47:38 by RouterOS 7.13
# model = RBD52G-5HacD2HnD
/interface bridge
add name=bridge-wifi vlan-filtering=yes
/interface vlan
add interface=bridge-wifi name=vlan-10-vip vlan-id=10
add interface=bridge-wifi name=vlan-20-guest vlan-id=20
add interface=bridge-wifi name=vlan-33-mgmt vlan-id=33
/interface wifi channel
add band=2ghz-n disabled=no name=ch-2 width=20mhz
add band=5ghz-ac disabled=no name=ch-5 skip-dfs-channels=all width=20/40mhz
/interface wifi datapath
add disabled=no name=data-main
add client-isolation=yes disabled=no name=data-guest
/interface wifi security
add authentication-types=wpa2-psk,wpa3-psk disabled=no ft=yes ft-over-ds=yes \
    name=sec-main wps=disable
add authentication-types=wpa2-psk,wpa3-psk disabled=no ft=yes ft-over-ds=yes \
    name=sec-guest wps=disable
/interface wifi configuration
add channel=ch-2 country=Poland datapath=data-main disabled=no mode=ap name=\
    cfg-main-2 security=sec-main ssid=wifi6-vip
add channel=ch-5 country=Poland datapath=data-main disabled=no manager=local \
    mode=ap name=cfg-main-5 security=sec-main ssid=wifi6-vip
add channel=ch-2 country=Poland datapath=data-guest disabled=no mode=ap name=\
    cfg-guest-2 security=sec-guest ssid=wifi6-guest
add channel=ch-5 country=Poland datapath=data-guest disabled=no mode=ap name=\
    cfg-guest-5 security=sec-guest ssid=wifi6-guest
/interface wifi
set [ find default-name=wifi1 ] configuration=cfg-main-2 \
    configuration.manager=local .mode=ap disabled=no
set [ find default-name=wifi2 ] configuration=cfg-main-5 \
    configuration.manager=local .mode=ap disabled=no
add configuration=cfg-guest-2 configuration.mode=ap disabled=no mac-address=\
    76:4D:28:B4:D6:F8 master-interface=wifi1 name=wifi3
add configuration=cfg-guest-5 configuration.mode=ap disabled=no mac-address=\
    76:4D:28:B4:D6:F9 master-interface=wifi2 name=wifi4
/ip pool
add name=dhcp_pool0 ranges=172.16.10.2-172.16.10.126
add name=dhcp_pool1 ranges=192.168.20.2-192.168.20.254
add name=dhcp_pool2 ranges=10.33.33.2-10.33.33.30
/ip dhcp-server
add address-pool=dhcp_pool0 interface=vlan-10-vip name=dhcp-vlan-10
add address-pool=dhcp_pool1 interface=vlan-20-guest name=dhcp-vlan-20
add address-pool=dhcp_pool2 interface=vlan-33-mgmt name=dhcp-mgmt
/interface bridge port
add bridge=bridge-wifi interface=wifi1 pvid=10
add bridge=bridge-wifi interface=wifi2 pvid=10
add bridge=bridge-wifi interface=wifi3 pvid=20
add bridge=bridge-wifi interface=wifi4 pvid=20
add bridge=bridge-wifi interface=ether4
/interface bridge vlan
add bridge=bridge-wifi tagged=bridge-wifi,ether4 vlan-ids=10
add bridge=bridge-wifi tagged=bridge-wifi,ether4 vlan-ids=20
add bridge=bridge-wifi tagged=bridge-wifi,ether4 vlan-ids=33
/interface wifi capsman
set enabled=yes interfaces=vlan-33-mgmt package-path="" \
    require-peer-certificate=no upgrade-policy=none
/interface wifi provisioning
add action=create-dynamic-enabled disabled=no master-configuration=cfg-main-2 \
    slave-configurations=cfg-guest-2 supported-bands=2ghz-n
add action=create-dynamic-enabled disabled=no master-configuration=cfg-main-5 \
    slave-configurations=cfg-guest-5 supported-bands=5ghz-ac
/ip address
add address=172.16.10.1/25 interface=vlan-10-vip network=172.16.10.0
add address=192.168.20.1/24 interface=vlan-20-guest network=192.168.20.0
add address=10.33.33.1/27 interface=vlan-33-mgmt network=10.33.33.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=10.33.33.0/27 dns-server=10.33.33.1 gateway=10.33.33.1
add address=172.16.10.0/25 dns-server=172.16.10.1 gateway=172.16.10.1
add address=192.168.20.0/24 dns-server=192.168.20.1 gateway=192.168.20.1
/ip dns
set allow-remote-requests=yes
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/system identity
set name=CAPsMAN
