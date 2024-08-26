pid=$(ps -e | grep qemu | awk '{print $1}')
if [ -n "$pid" ];then
    kill -9 $pid 
fi
