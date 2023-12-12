#!/bin/bash

cat > index.html <<EOF
<h1>Hej och hå smörgåsbord!</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
<p>HW: $(uname -a)</p>
<p>Time: $(date)</p>
EOF

nohup busybox httpd -f -p ${server_port} &
