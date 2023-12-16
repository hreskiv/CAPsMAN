# 2023-12-16 13:47:13 by RouterOS 7.13
# model = RBwAPGR-5HacD2HnD
/interface bridge
add name=bridge-wifi vlan-filtering=yes
/interface wifi
set [ find default-name=wifi1 ] configuration.manager=capsman .mode=ap \
    disabled=no
set [ find default-name=wifi2 ] configuration.manager=capsman .mode=ap \
    disabled=no
/interface lte
set [ find default-name=lte1 ] allow-roaming=no band=""
/interface vlan
add interface=bridge-wifi name=vlan-10-vip vlan-id=10
add interface=bridge-wifi name=vlan-20-guest vlan-id=20
add interface=bridge-wifi name=vlan-33-mgmt vlan-id=33
/interface wifi datapath
add disabled=no name=data
/interface wifi
add datapath=data disabled=no master-interface=\
    wifi2 name=wifi7
add datapath=data disabled=no master-interface=\
    wifi1 name=wifi8
/interface bridge port
add bridge=bridge-wifi interface=ether1
add bridge=bridge-wifi interface=wifi1 pvid=10
add bridge=bridge-wifi interface=wifi2 pvid=10
add bridge=bridge-wifi interface=wifi7 pvid=20
add bridge=bridge-wifi interface=wifi8 pvid=20
/interface bridge vlan
add bridge=bridge-wifi tagged=bridge-wifi,ether1 vlan-ids=10
add bridge=bridge-wifi tagged=bridge-wifi,ether1 vlan-ids=20
add bridge=bridge-wifi tagged=bridge-wifi,ether1 vlan-ids=33
/interface wifi cap
set caps-man-addresses=10.33.33.1 enabled=yes slaves-datapath=data \
    slaves-static=yes
/ip dhcp-client
add interface=vlan-33-mgmt
/ip firewall filter
add action=drop chain=output disabled=yes dst-address=192.168.10.1 protocol=\
    icmp
/system identity
set name=CAP
