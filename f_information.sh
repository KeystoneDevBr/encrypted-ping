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
f_information(){
 #----------------------- Show Information About VM-------------------------------------
 dialog \
   --backtitle "$BACKTITLE" \
   --title "ABOUT CRYPTED PING APP" \
   --cr-wrap \
   --msgbox "
   ----------------------- RELEASES -----------------------------

   Version: 1.0.0
   Released at January 14, 2013

   -------------------- HOST INFORMATION ------------------------
   Hostname:   $(hostname)
   User:      $USER
   Distribution: $(lsb_release -d | awk -F: '{print $NF}')
   SSH Client: $( echo "$SSH_CLIENT" | awk '{print $1}')
   IPs:         $(hostname -I)

   ---------------------- ABOUT AUTORS ---------------------------

   Develop by Fagne Tolentino Reges

   Under the supervision of Dr. Georges Daniel Amvame Nze, 
   from University of Brasilia - Brazil
   " 0 0

  
 #--------------------------------------------------------------------------------------
}
f_information
#########################################################################################