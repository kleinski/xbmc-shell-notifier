#!/bin/bash
#
# Sends notification to a XBMC specified by arguments
# Usage: call-xbmc.sh "Example Text" 10000 raspberry 8080
#
# Notification will be the hostname of your client + "says:"
#
# m@rcus.net - 01/2013
#
# Tested on Mac OS X 10.7.5 with GNU bash, 
# Version 4.2.42(2)-release-(i386-apple-darwin11.4.2)
#
# Comes without any warranty
#
# 


# Checking arguments
if [ $# -ne 4 ]
then   
        echo -e "\nUsage: \t\t`basename $0` \"<Notificationtext>\" <Displaytime ms> <Targethost> <Targetport>"
        echo -e  "Example1: \t`basename $0` \"xbmc-hostname will be resolved\" 10000 raspberry 8080"
        echo -e  "Example2: \t`basename $0` \"sometimes it is better to use the ip\" 10000 10.2.20.37 3000\n"
        exit 1
else   
        NTEXT=$1
        DTIME=$2
        THOST=$3
        TPORT=$4
fi

##### Please modify for your needs ####
USER=YOURNAME
PASS=YOURPASS
##### #### #### ######## #### #### #### 

LOGHDL=/tmp/result.xmbc.rpc.$$
CMDFILE=/tmp/send.2.xbmc.$$

# Curl-Call
PROGRAMCALL="curl -o $LOGHDL -su $USER:$PASS -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '"
FUNCTIONCALL="{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"GUI.ShowNotification\",\"params\":{\"title\":\"`hostname -s` \
         says:\",\"message\":\"$NTEXT\",\"image\":\"\",\"displaytime\":$DTIME}}' http://$THOST:$TPORT/jsonrpc"
RPCCMD="$PROGRAMCALL $FUNCTIONCALL"

# Out- and insourcing the command
echo $RPCCMD > $CMDFILE
source $CMDFILE

# Execute RemoteProcedure 
$RPCCMD

# Check on errors
grep -q OK $LOGHDL 
ERR=$?
if 
        [ $ERR -ne 0 ] 
then  
        echo FAILURE -  Errorcode=$ERR
        echo >> $LOGHDL
        echo RPC
        cat $CMDFILE
        echo Result
        cat $LOGHDL
        exit $ERR
else
        rm -f $LOGHDL
        rm -f $CMDFILE
fi

exit 0
