#!/bin/bash
LOG=/opt/kubernetes/logs/keepalive.log


err=0
# 循环检查的次数，循环检测次数 k * 循环检测时间 sleep 不能超过 keepalive的休息时间interval 5
for k in $(seq 1 4)
do
    # echo "k is ${k}" >> /var/log/kubernetes/keepalive.log
    check_code=$(curl -k -s https://127.0.0.1:6443/healthz)
    echo "check code ${check_code}" >> ${LOG}
    if [[ $check_code != "ok" ]];then
        err=$(expr $err + 1)
        echo "api is fail" >> ${LOG}
        echo "err time $err" >> ${LOG}
        echo "=========${k}========" >> ${LOG}
        # 循环休息时间
        sleep 1
        continue
    else
        echo "api is ok" >> ${LOG}
        err=0
        break
    fi  

    echo "==============================" >> ${LOG}
done
if [[ $err != "0" ]];then
    #echo "systemctl stop keepalived"
    echo "systemctl stop keepalived" >> ${LOG}
    /usr/bin/systemctl stop keepalived
    exit 1
else
    exit 0
fi 
