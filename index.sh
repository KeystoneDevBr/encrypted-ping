#!/bin/bash
#########################################################################################
# This Script was create by Fagne Tolentio Reges
# Date: 2023-01-14 update at: 
#
# This function call the Dialog Menu with meny options for start the Crypted Ping app
#
# 
#
#########################################################################################

#Default variables
BACKTITLE="Crypted Ping Verion 1.0.0"
APP_PATH=$(pwd)

#Configure Dialog for use personalized teme
export DIALOGRC="$APP_PATH/.dialogrc"

#----------------------- Default Menu Start----------------------------------------------
start() {
    while :; do
        shoices=$(
            dialog --stdout \
                --backtitle "$BACKTITLE" \
                --title "DEFAULT MENU" \
                --menu "Select one option" \
                0 0 0 \
                Information 'Dipslay App Information' \
                Send 'Send Ping Messages' \
                Sniff 'Sniff Ping Messages' \
                Exit 'End Section'
        )

        #If CALCEL buttons was pressed,  end this section
        [ $? = 1 ] && clear && break

        case "$shoices" in
        Information)
            sudo bash "$APP_PATH/f_information.sh"
            ;;
        Send)
            sudo bash "$APP_PATH/f_seng_ping.sh"
            ;;
        Sniff)
            sudo bash "$APP_PATH/f_sniff_ping.sh"
            ;;
        Exit) clear && exit 1 ;;
        esac

    done
#----------------------- Default Menu End  ----------------------------------------------

    echo 'Tchau' "$USER"
#########################################################################################
}
start
