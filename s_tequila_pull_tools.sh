s_tequila_pull.sh dev/irda/src/out/host/linux-x86/bin/* .
s_tequila_pull.sh dev/irda/src/prebuilts/devtools/tools/* .
s_tequila_pull.sh dev/irda/src/prebuilts/devtools/tools/lib/* .
s_tequila_pull.sh dev/irda/src/out/host/linux-x86/framework/* .
s_tequila_pull.sh dev/irda/src/sdk/monitor/monitor .
mkdir -p x86_64
s_tequila_pull.sh dev/irda/src/prebuilts/tools/linux-x86_64/swt/swt.jar x86_64
