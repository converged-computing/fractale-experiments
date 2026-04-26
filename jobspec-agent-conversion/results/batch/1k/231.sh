#!/bin/bash

cmd=`basename $0`

if [ ! -f $1 ]; then
    echo "Error: $1 does not exist."
    exit 1
fi 

wc=`wc -l $1|awk '{ print $1 }'`

cat <<EOF
#!/bin/bash
#FLUX: --job-name=`basename $1`
#FLUX: --cc=1-$wc
bash -c '$( sed -n \${FLUX_JOB_CC}p $1)'
EOF
