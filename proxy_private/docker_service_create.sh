# delete existing service
docker service rm proxy_private

# create new service
docker service create \
  --name proxy_private \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --publish mode=host,target=9001,published=9001 \
  --publish mode=host,target=9002,published=9002 \
  --publish mode=host,target=9003,published=9003 \
  --publish mode=host,target=9004,published=9004 \
  --publish mode=host,target=9005,published=9005 \
  --publish mode=host,target=9006,published=9006 \
  --publish mode=host,target=9007,published=9007 \
  --publish mode=host,target=9008,published=9008 \
  --publish mode=host,target=9009,published=9009 \
  --publish mode=host,target=9010,published=9010 \
  --publish mode=host,target=9011,published=9011 \
  --publish mode=host,target=9012,published=9012 \
  --publish mode=host,target=9013,published=9013 \
  --publish mode=host,target=9014,published=9014 \
  --publish mode=host,target=9015,published=9015 \
  --publish mode=host,target=9016,published=9016 \
  --publish mode=host,target=9017,published=9017 \
  --publish mode=host,target=9018,published=9018 \
  --publish mode=host,target=9019,published=9019 \
  --publish mode=host,target=9020,published=9020 \
  --publish mode=host,target=9021,published=9021 \
  --publish mode=host,target=9022,published=9022 \
  --publish mode=host,target=9023,published=9023 \
  --publish mode=host,target=9024,published=9024 \
  --publish mode=host,target=9025,published=9025 \
  --publish mode=host,target=9026,published=9026 \
  --publish mode=host,target=9027,published=9027 \
  --publish mode=host,target=9028,published=9028 \
  --publish mode=host,target=9029,published=9029 \
  --publish mode=host,target=9030,published=9030 \
  --publish mode=host,target=9031,published=9031 \
  --publish mode=host,target=9032,published=9032 \
  --publish mode=host,target=9033,published=9033 \
  --publish mode=host,target=9034,published=9034 \
  --publish mode=host,target=9035,published=9035 \
  --publish mode=host,target=9101,published=9101 \
  --publish mode=host,target=9102,published=9102 \
  --publish mode=host,target=9103,published=9103 \
  --publish mode=host,target=9104,published=9104 \
  --publish mode=host,target=9105,published=9105 \
  --publish mode=host,target=9106,published=9106 \
  --publish mode=host,target=9107,published=9107 \
  --publish mode=host,target=9108,published=9108 \
  --publish mode=host,target=9109,published=9109 \
  --publish mode=host,target=9110,published=9110 \
  --publish mode=host,target=9111,published=9111 \
  --publish mode=host,target=9112,published=9112 \
  --publish mode=host,target=9113,published=9113 \
  --publish mode=host,target=9114,published=9114 \
  --publish mode=host,target=9115,published=9115 \
  --publish mode=host,target=9116,published=9116 \
  --publish mode=host,target=9117,published=9117 \
  --publish mode=host,target=9118,published=9118 \
  --publish mode=host,target=9119,published=9119 \
  --publish mode=host,target=9120,published=9120 \
  --publish mode=host,target=9121,published=9121 \
  --publish mode=host,target=9122,published=9122 \
  --publish mode=host,target=9123,published=9123 \
  --publish mode=host,target=9124,published=9124 \
  --publish mode=host,target=9125,published=9125 \
  --publish mode=host,target=9126,published=9126 \
  --publish mode=host,target=9127,published=9127 \
  --publish mode=host,target=9128,published=9128 \
  --publish mode=host,target=9129,published=9129 \
  --publish mode=host,target=9130,published=9130 \
  --publish mode=host,target=9131,published=9131 \
  --publish mode=host,target=9132,published=9132 \
  --publish mode=host,target=9133,published=9133 \
  --publish mode=host,target=9134,published=9134 \
  --publish mode=host,target=9135,published=9135 \
  --network cosmosia \
  --constraint 'node.hostname==cosmosia7' \
  --secret ssl_notional.ventures.tar.gz \
  --restart-condition any \
  --restart-delay 3s \
  --restart-max-attempts 3 \
  --restart-window 10m \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/proxy_private/run.sh > ~/run.sh && /bin/bash ~/run.sh"


