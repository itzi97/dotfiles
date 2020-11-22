#!/bin/bash

# All "custom" vpns, are prefixed with "vpn-" as the tunnel name
PIA=$(piactl get connectionstate)

if [[ "${PIA}" == "Connected" ]]; then
	PIA_COUNTRY=$(piactl get region | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g')
	echo "%{F#61C766}""%{F-}" "${PIA_COUNTRY}"
else
	echo ""
fi
