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
BACKTITLE="Send Ping Messages"
APP_PATH=$(pwd)

#Configure Dialog for use personalized teme
export DIALOGRC="$APP_PATH/.dialogrc"
#-------------------------- Send Menu Start----------------------------------------------
f_send_ping() {
    DEFAULT_PING() {
        HOST=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Host address" \
            --inputbox 'Enter the destination IP' \
            0 0 "192.168.30.5")

        clear
        echo "Waiting for the message......"

        sudo ping $HOST -c 4 >/tmp/ping.txt

        dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title 'Ping response' \
            --textbox /tmp/ping.txt \
            0 0
        sudo rm -f /tmp/ping.txt
    }

    UNCRYPTED_PING() {
        HOST=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Host address" \
            --inputbox 'Enter the destination IP' \
            0 0 "192.168.30.")

        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255 ] && return 1 # Esc
        [ $return -eq 1 ] && return 1   # Cancel

        MSG=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Uncrypted Message" \
            --inputbox 'Enter the message' \
            0 0 "Clear message to send")

        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255 ] && return 1 # Esc
        [ $return -eq 1 ] && return 1   # Cancel

        CAN_SEND=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Uncrypted Message" \
            --cr-wrap \
            --yesno "
                Do you want send this message to $HOST ?:

                Message:

                $MSG" 0 0)
        if [ $? -eq 0 ] ; then
            #Try Sending message
            clear; echo "Sending the message................"; sleep 3;
            # Try to send the message
            RESULT=""
            RESULT=$(sudo python3 icmp-send.py -cn -a "$HOST" -m "$MSG" -q 4 )
            
            #Show feedback
            dialog \
                --backtitle "$BACKTITLE" \
                --title "Uncrypted Message sended" \
                --cr-wrap \
                --msgbox " 
                Clear Message sended to $HOST.

                $RESULT
                
            "  0 0
        fi
    }

    CRYPTED_PING() {
        HOST=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Host address" \
            --inputbox 'Enter the destination IP' \
            0 0 "192.168.30.")

        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255 ] && return 1 # Esc
        [ $return -eq 1 ] && return 1   # Cancel

        MSG=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Crypted Message" \
            --inputbox 'Enter the message' \
            0 0 "Crypted message to send")
        
        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255 ] && return 1 # Esc
        [ $return -eq 1 ] && return 1   # Cancel

        KEY=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Crypted Message" \
            --inputbox 'Enter the message key' \
            0 0 "key")
    
        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255 ] && return 1 # Esc
        [ $return -eq 1 ] && return 1   # Cancel

        CAN_SEND=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Uncrypted Message" \
            --cr-wrap \
            --yesno "
                Do you want send this message to $HOST ?:

                Message:

                $MSG" 0 0)

        if [ $? -eq 0 ] ; then
            #Try Sending message
            clear; echo "Sending the message................"; sleep 3;
            # Try to send the message
            RESULT="";
            RESULT=$(sudo python3 ./icmp-send.py -cy -k "$KEY" -a "$HOST" -m "$MSG" -q 4 )
            
            #Show feedback
            dialog \
                --backtitle "$BACKTITLE" \
                --title "Crypted Message Sended" \
                --cr-wrap \
                --msgbox " 
                Cryted Message sended to $HOST.

                $RESULT
                
            "  0 0
        fi

    }

    while :; do
        resposta=$(
            dialog --stdout \
                --backtitle "$BACKTITLE" \
                --title 'Send Menu' \
                --menu 'Select the type of the ping' \
                0 0 0 \
                Default 'Send a default Ping' \
                Uncrypted 'Send a uncrypted Ping' \
                Crypted 'Send a Crypted Ping' \
                Back 'Back'
        )

        # Usuario pressionou ESC ou Cancelar
        [ $? -ne 0 ] && break

        # De acordo com a opcao escolhida faz o ping
        case "$resposta" in
        Default) DEFAULT_PING ;;
        Uncrypted) UNCRYPTED_PING ;;
        Crypted) CRYPTED_PING ;;
        Back) break ;;
        esac
    done
}
f_send_ping
