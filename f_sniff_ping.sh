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
BACKTITLE="Sniff Ping Messages"
APP_PATH=$(pwd)

#Configure Dialog for use personalized teme
export DIALOGRC="$APP_PATH/.dialogrc"

#------------------------- Sniff Menu Start----------------------------------------------
f_sniff_ping() {

    SNIFF_PING() {
        #Clear messages
        sudo rm /tmp/echo-request.txt
        
        #Star the sniffer for receive the crypted message
        #sudo tcpdump 'icmp[icmptype] == icmp-echo' -XX 2>/dev/null 1>/dev/null >/tmp/echo-request.txt &

        #Dialog Screen
        #dialog \
        #    --backtitle "$BACKTITLE" \
        #    --title "Waiting for: tcpdump 'icmp[icmptype] == icmp-echo' -XX" \
        #    --tailbox /tmp/echo-request.txt \
        #    40 90
        
        #Alternative option to dialog screen
        sudo clear; sudo echo "Waiting for: tcpdump 'icmp[icmptype] == icmp-echo' -XX";
        sudo watch -n 0.5 "sudo echo Waiting for: tcpdump 'icmp[icmptype] == icmp-echo' -XX ;sudo tcpdump 'icmp[icmptype] == icmp-echo' -XX -c1 ; printf '\n \n Press Ctrl + C for exit'"    
    }

    UNCRYPTED_PING() {
        HOST=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --max-input 31 \
            --title "Host address" \
            --inputbox 'Inform the source ip address' \
            0 0 "192.168.30.")
        
        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255   ] && return 1 # Esc
        [ $return -eq 1 ] && return 1     # Cancel

        clear
        echo "Waiting for the message......"

        #Star the sniffer for receive the crypted message
        UNCRYPTED_RESULT=$( sudo python3 ./icmp-receive.py -c n -a $HOST )

        sleeep 10;
        dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Uncrypted Message Received from $HOST" \
            --msgbox "$(echo $UNCRYPTED_RESULT)" \
            20 0 ;        
    }

    CRYPTED_PING() {
        HOST=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --max-input 31 \
            --title "Host address" \
            --inputbox 'Inform the source ip address' \
            0 0 "192.168.30.1")

        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255   ] && return 1 # Esc
        [ $return -eq 1 ] && return 1     # Cancel

        KEY=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Message Key" \
            --inputbox 'Inform the message key' 0 0 "key")
        
        return=$?
        # Exit if CALCEL button pressed
        [ $return -eq 255   ] && return 1 # Esc
        [ $return -eq 1 ] && return 1     # Cancel

        #Star the sniffer for receive the crypted message
        clear;
        echo " " | sudo tee > /tmp/msg_decrypted.txt

        echo "Waiting for the message......"

        CRYPTED_RESULT=$(sudo python3 ./icmp-receive.py -cy -k $KEY -a $HOST )
        
        #sudo python3 ./icmp-receive.py -cy -k $KEY -a $HOST -f $file

        message=$(dialog --stdout \
            --backtitle "$BACKTITLE" \
            --title "Crypted Message Received from $HOST" \
            --msgbox "$(echo $CRYPTED_RESULT)" \
            20 0 )

        sudo rm -f /tmp/msg_decrypted.txt
    }

    while :; do
        resposta=$(
            dialog --stdout \
                --backtitle "$BACKTITLE" \
                --title 'Sniff Menu' \
                --menu 'Select the type of the ping for sniff' \
                0 0 0 \
                Sniff 'Sniff icmp echo-request packages' \
                Uncryped 'Sniff a uncrypted Ping' \
                Crypted 'Sniff a Crypted Ping' \
                Back 'Back'
        )

        # Usuario pressionou ESC ou Cancelar
        [ $? -ne 0 ] && break

        # De acordo com a opcao escolhida faz o ping
        case "$resposta" in
        Sniff) SNIFF_PING ;;
        Uncryped) UNCRYPTED_PING ;;
        Crypted) CRYPTED_PING ;;
        Back) break ;;
        esac
    done
}
f_sniff_ping
