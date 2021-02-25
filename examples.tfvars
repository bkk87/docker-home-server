# pihole

pihole_env_list = [
    "ServerIP=x.x.x.x",
    "TZ=Europe/Berlin",
    "IPv6=True",
    "PIHOLE_DNS_=x.x.x.x;x.x.x.x",
    "ServerIPv6=fd00::x:x:x:x",
    "REV_SERVER=true",
    "REV_SERVER_DOMAIN=x.x",
    "REV_SERVER_TARGET=x.x.x.x",
    "REV_SERVER_CIDR=x.x.x.x/xx",
  "VIRTUAL_HOST=x.fritz.box"]

# traefik

user_digest_auth="username:traefik:xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
duckdns_domain_name="xxxxxxxxxxxx.duckdns.org"
internal_domain_name="x.fritz.box"
letsencrypt_email="xxxxxxxxxxxx"

# nextcloud

nextcloud_admin_username="xxxxxxxxxxxx"
