#!/bin/sh
#set -eu

#2018/01/29  for GlusterStorage 3.3.0

#nagios_reconfig.sh [gluster volume name]
#nagiosÝ’èŽžAbrick‚ª³í‚È‚Ì‚ÉCritical‚É‚È‚éŒ»Û‚ðC³‚·‚é
#Correct that brick is normal but it becomes critical status by nagios.
#https://access.redhat.com/solutions/3215601
#Please grant execute permission. "chmod +x nagios_reconfig.sh"

if [ $# -eq 0 ]; then
  echo "Not input volume name." 1>&2
  echo "nagios_reconfig.sh [gluster volume name]" 1>&2
  exit 1
fi

####volume exist check####
goflag=0

for var in `ls -1 /var/run/gluster/vols`
do
if [ $1 = $var ]; then goflag=1; fi
done

if [ $goflag != 1 ]; then echo "Not exist volume \"$1\"."; exit 1; fi
##########################


mkdir /var/lib/glusterd/vols/$1/run 2>/dev/null
cd /var/run/gluster/vols/$1/

#if [ $2 = clear ]; then
rm /var/lib/glusterd/vols/$1/run/* 2>/dev/null
#fi

for var in `ls -1 *.pid`
do
ln -s  /var/run/gluster/vols/$1/$var /var/lib/glusterd/vols/$1/run/$var
echo "Create $var"
done

service nagios restart

echo "Completed."

