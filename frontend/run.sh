#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset

trap "exit" INT TERM

domains=${DOMAINS:-localhost}

get_domain_flags() {
    local domain_flags=""

    for domain in $domains; do
        domain_flags="$domain_flags -d $domain"
    done

    echo "$domain_flags"
}

replace() {
    sed -i "s~<DOMAINS>~$domains~g" /etc/nginx/conf.d/default.conf
    sed -i "s~<SSL_PATH>~$SSL_PATH~g" /etc/nginx/conf.d/default.conf
}

run_lego() {
    local first_domain=$(printf "%s" "${domains%% *}")

    lego --http.webroot /app \
        --email $EMAIL \
        --http \
        --accept-tos \
        --path /etc/ssl/lego \
        $(get_domain_flags) \
        run

    rm "${SSL_PATH}"/app.key
    rm "${SSL_PATH}"/app.crt
    ln -s /etc/ssl/lego/certificates/"${first_domain}".crt "${SSL_PATH}"/app.crt
    ln -s /etc/ssl/lego/certificates/"${first_domain}".key "${SSL_PATH}"/app.key
}

setup_cron() {
    echo "0 0 * * 0 lego --http.webroot /app --email $EMAIL --http --path /etc/ssl/lego $(get_domain_flags) renew >> /var/log/lego.log && /usr/sbin/nginx -s reload" > /etc/crontabs/lego
    crontab /etc/crontabs/lego
    crond
}

replace && nginx -g "daemon off;" &
nginx_pid=$!

if [[ "$domains" != "localhost"  ]]; then
    run_lego
    setup_cron
fi

nginx -s reload
wait $nginx_pid