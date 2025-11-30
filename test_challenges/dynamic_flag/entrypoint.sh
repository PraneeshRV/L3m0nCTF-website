#!/bin/sh

if [ -z "$FLAG" ]; then
    echo "FLAG environment variable is not set!"
    export FLAG="L3m0n{default_flag_if_env_missing}"
fi

echo "Starting challenge with flag: $FLAG"
socat TCP-LISTEN:1337,reuseaddr,fork EXEC:"echo $FLAG"
