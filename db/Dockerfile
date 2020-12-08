FROM postgres:12

RUN openssl req -new -text -passout pass:abcd -subj /CN=localhost -out /var/lib/postgresql/server.req -keyout privkey.pem
RUN openssl rsa -in privkey.pem -passin pass:abcd -out /var/lib/postgresql/server.key
RUN openssl req -x509 -in /var/lib/postgresql/server.req -text -key /var/lib/postgresql/server.key -out /var/lib/postgresql/server.crt

RUN chmod 600 /var/lib/postgresql/server.key
RUN chown postgres:postgres /var/lib/postgresql/server.key