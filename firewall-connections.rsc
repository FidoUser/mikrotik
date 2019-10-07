#work only on hardware mikrotik because use ip cloud

/ip cloud
set ddns-enabled=yes

/system script
add dont-require-permissions=no name=check-wan-ip owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global wanIP\r\
    \n# :set wanIP \"sd\"\r\
    \n:local CurWan [/ip cloud get public-address]\r\
    \n\r\
    \n:if (\$wanIP != \$CurWan  ) do={ \r\
    \n\t:log warning \"change WAN IP from \$wanIP to \$CurWan\"\r\
    \n\t:set wanIP \$CurWan \r\
    \n\t/ip firewall connection remove [find  dst-address~\":5060\" protocol~\"udp\" ] \r\
    \n\t:delay 5\r\
    \n\t#/ip firewall connection remove [find  dst-address~\":5060\" protocol~\"udp\" ] \r\
    \n\t\r\
    \n}\r\
    \n"

/system scheduler
add interval=1m name=check-wan-ip on-event=check-wan-ip policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=oct/07/2019 start-time=00:00:00
