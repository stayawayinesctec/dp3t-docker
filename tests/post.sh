#!/usr/bin/env bash

if [ $# -lt 2 ]; then
	echo $0 "yyyy-mm-dd code"
	exit 1
fi

BASE=https://localhost

#OPT="--verbose --insecure"
OPT="-s --insecure"

code=$2$3$4$5
keydate=$(($(date --date=$1 +%s)/600))
key=$(echo $(date -Ins) "padpadpadpadpadpadpad" | cut -c-15 | base64)

echo "Code: $code, rollingstart: $keydate, key: $key"

repl=$(curl $OPT \
	-X POST -H "accept: */*" \
	-H "Content-Type: application/json" \
	-d "{\"authorizationCode\":\"$code\",\"fake\":\"0\"}" \
	"$BASE/v1/onset")

if grep -q accessToken <<< $repl ; then
	token=$(echo $repl | cut -d\" -f4)
else
	echo "No token"
	exit 1
fi

echo "Got token $token"

curl $OPT \
	-X POST -H "accept: */*" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $token" \
	-d @- \
  	$BASE/v2/gaen/exposed <<EOF
{
	"international": 0,
	"gaenKeys": [
		{"keyData":"$key","rollingStartNumber":$keydate,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":0},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1},
		{"keyData":"$key","rollingStartNumber":0,"rollingPeriod":144,"transmissionRiskLevel":4,"fake":1}
	]
}
EOF

