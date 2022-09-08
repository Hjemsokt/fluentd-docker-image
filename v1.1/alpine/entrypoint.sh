#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-1000}

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
adduser -D -g '' -u ${uid} -h /home/fluent fluent

# chown home and data folder
chown -R fluent /home/fluent
chown -R fluent /fluentd

if [ ! ${OUT_MOD} ]; then
    ln -s /fluentd/etc/out_file.conf  /fluentd/etc/out.conf
else
    ln -s /fluentd/etc/out_${OUT_MOD}.conf  /fluentd/etc/out.conf
fi

#exec su-exec fluent "$@"
exec su-exec root "$@"
