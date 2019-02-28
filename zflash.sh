BOARDS=("F4 VCP" "F4 RNDIS" "F7 RNDIS")
BOARD=$(zenity --list --column=BOARD "${BOARDS[@]}")

case "${BOARD[@]}" in  
	"F4 VCP") 
		echo "Flashing F4 vcp"
		load_F4_vcp.sh
	;;
	"F4 RNDIS") 
		echo "Flashing F4 rndis"
		load_F4_rndis.sh
	;;
	"F7 RNDIS") 
		echo "Flashing F7"
		load_F7_rndis.sh
	;;
esac

