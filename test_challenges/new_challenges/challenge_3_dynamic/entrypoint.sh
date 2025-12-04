#!/bin/sh

if [ -z "$FLAG" ]; then
    echo "FLAG environment variable is not set!"
    export FLAG="L3m0n{default_flag_oops}"
fi

echo "Starting challenge with dynamic flag..."
socat TCP-LISTEN:1337,reuseaddr,fork EXEC:"echo $FLAG"
