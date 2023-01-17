#! /usr/bin/env python
from scapy.all import *
import argparse
import hashlib
import math
import os
from Crypto.Cipher import AES

# Default constats
IV_SIZE = 16 # 128 bit, fixed for the AES algorithm
KEY_SIZE = 32 # 256 bit meaning AES-256, can also be 128 or 192 bits
SALT_SIZE = 16 # This size is arbitrary

def pingHandle(for_decrypt,host_address,ping_quantity=1,msg_key='foo'):

    #Prepare the filter
    if host_address != 'None':
        filter = 'icmp and host '+str(host_address)
    else:
        filter = 'icmp'
    
    #Sniff the message
    ping_in = ping_in=sniff(filter=filter, count=ping_quantity)
    pingReceived = ping_in[ping_quantity-1].load
    
    if for_decrypt :
        pingDecrypt(pingReceived,msg_key)
    else:
        #Delete old messages
        uncryptedMessage = pingReceived.decode('utf-8') 
        with open('/tmp/msg_uncrypted.txt', 'w', encoding='utf-8') as file:
            file.write("")
            file.write(uncryptedMessage)
    
def pingDecrypt(pingReceived,msg_key):
    """ --- This function decrypt the message received --- """
    #print(pingReceived)  #Only for debug

    #Convert the message key from string to bytes
    bytes_msg_key = msg_key.encode()
    
    #Decrypt the message with the key
    salt = pingReceived[0:SALT_SIZE]
    derived = hashlib.pbkdf2_hmac('sha256', bytes_msg_key, salt, 100000, dklen=IV_SIZE + KEY_SIZE)
    iv = derived[0:IV_SIZE]
    key = derived[IV_SIZE:]
    cleartext = AES.new(key, AES.MODE_CFB, iv).decrypt(pingReceived[SALT_SIZE:])

    #Delete old messages
    with open('/tmp/msg_decrypted.txt', 'w', encoding='utf-8') as file:
        file.write('')

    #Handle with decrypted message
    decrytedMsg = cleartext.decode()
    with open('/tmp/msg_decrypted.txt', 'w', encoding='utf-8') as file:
        file.write(decrytedMsg)

if __name__ == '__main__':

    # Get input parameters from
    input_parser = argparse.ArgumentParser(description='This Script sniffing the Crypto ICMP package')
    # Input rules and help info
    input_parser.add_argument('-c', action="store",help='The message is crypted? [y|n]', required=True)
    input_parser.add_argument('-k', action="store",help='Message key for decrypt', required=False)
    input_parser.add_argument('-q', action="store",help='Number of ping to listening', required=False)
    input_parser.add_argument('-a', action="store",help='Host address source of the message [X.X.X.X]', required=False)

    # Prepare input
    get_inputs = vars(input_parser.parse_args())
    
    is_crypted      = str(get_inputs["c"])
    ping_quantity   = 1
    host_address    = str(get_inputs["a"])
   
    if get_inputs["q"] is not None:
        ping_quantity = int(get_inputs["q"])
    
  
    #Get more information if the message is crypted
    if is_crypted == 'n':
        for_decrypt = False
        msg_key = ""
        #print('Waiting uncrypted message')  
        pingHandle(for_decrypt,host_address,ping_quantity,msg_key)

    else:
        if (is_crypted == 'y' and get_inputs["k"] is not None):    
            for_decrypt = True
            msg_key = str(get_inputs["k"])
            #print("Waiting crypted message")
            pingHandle(for_decrypt,host_address,ping_quantity,msg_key)
        else:
            print("The parameters -k or -n are note defined.")      
    #end

    
 
    
