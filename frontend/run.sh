#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset

trap "exit" INT TERM

domains=${DOMAINS:-localhost}

replace() {
    sed -i "s~<DOMAINS>~$domains~g" /etc/nginx/conf.d/default.conf
    sed -i "s~<SSL_PATH>~$SSL_PATH~g" /etc/nginx/conf.d/default.conf
}

run_lego() {
    local domain_flags=""
    local first_domain=$(printf "%s" "${domains%% *}")

    for domain in $domains; do
        domain_flags="$domain_flags -d $domain"
    done

    lego --http.webroot /app \
        --email $EMAIL \
        --http \
        --accept-tos \
        --path /etc/ssl/lego \
        $domain_flags \
        run

    rm "${SSL_PATH}"/app.key
    rm "${SSL_PATH}"/app.crt
    ln -s /etc/ssl/lego/certificates/"${first_domain}".crt "${SSL_PATH}"/app.crt
    ln -s /etc/ssl/lego/certificates/"${first_domain}".key "${SSL_PATH}"/app.key
}

replace && nginx -g "daemon off;" &
nginx_pid=$!

if [[ "$domains" != "localhost"  ]]; then
    run_lego
fi

wait $nginx_pid