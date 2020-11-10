#!/bin/sh
istio_home=/tfsagent/scripts/istio-task/
config_url=`cat $istio_home/kube.log |grep command |awk -F " " {'print $4'}`

echo $config_url > $istio_home/config_url.txt

cat $istio_home/config_url.txt |grep "config"

if [ $? -ne 0 ];then
exit;
fi

kubectl get gw,dr,vs -n $2

for file in $(ls -l $1 |grep -v total |awk {'print $9'}) ;do istioctl kube-inject -f $1/$file --kubeconfig=$config_url |kubectl $2 -f - -n $3 --kubeconfig=$config_url ;done
