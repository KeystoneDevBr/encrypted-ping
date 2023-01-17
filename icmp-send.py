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

def pingHandle(for_crypt,host_address,msg,ping_quantity=1,msg_key='foo'):
      
    if for_crypt :
        pingCrypted(host_address,msg,ping_quantity,msg_key)
    else:
        pingClean(host_address,msg,ping_quantity)

def pingClean(host_address, msg, ping_quantity):
    #Seng n clear message 
    sr1(IP(dst=host_address)/ICMP()/msg)
    #Show feedback
    print('\nSended Message: \n')
    print(msg)

def pingCrypted(host_address,msg,ping_quantity, msg_key):
    #Prepare the cryptograf
    cleartext = msg.encode()
    password = msg_key.encode()
    salt = os.urandom(SALT_SIZE)
    derived = hashlib.pbkdf2_hmac('sha256', password, salt, 100000,
    dklen=IV_SIZE + KEY_SIZE)
    iv = derived[0:IV_SIZE]
    key = derived[IV_SIZE:]
    encrypted = salt + AES.new(key, AES.MODE_CFB, iv).encrypt(cleartext)
    
    #Send the crypted message
    sr1(IP(dst=host_address)/ICMP()/encrypted)
    #Show feedback
    print('\nCrypted Message Sended: \n')
    print(encrypted)



if __name__ == '__main__':

    # Get input parameters from
    input_parser = argparse.ArgumentParser(description='This Script sniffing the Crypto ICMP package')
    # Input rules and help info
    input_parser.add_argument('-c', action="store",help='The message is crypted? [y|n]', required=True)
    input_parser.add_argument('-k', action="store",help='Message key to crypt', required=False)
    input_parser.add_argument('-a', action="store",help='Host address to send the message [X.X.X.X]', required=True)
    input_parser.add_argument('-m', action="store",help='Message to send', required=True)
    input_parser.add_argument('-q', action="store",help='Number of ping to send', required=False)

    # Prepare input
    get_inputs = vars(input_parser.parse_args())
    
    is_crypted      = str(get_inputs["c"])
    ping_quantity   = 2
    host_address    = str(get_inputs["a"])
    msg             = str(get_inputs["m"])

    if get_inputs["q"] is not None:
        ping_quantity = int(get_inputs["q"])
    
    if get_inputs["q"] is not None:
        ping_quantity = int(get_inputs["q"])
    
    #Get more information if the message is crypted
    if is_crypted == 'n' and msg is not None and host_address is not None:
        for_crypt = False
        msg_key = ""
        #print('Send uncrypted message') 
        pingHandle(for_crypt,host_address,msg,ping_quantity,msg_key) 

    else:
        if (is_crypted == 'y' and get_inputs["k"] is not None and get_inputs["m"]):    
            for_crypt = True
            msg_key = str(get_inputs["k"])
            #print("Send crypted message")
            pingHandle(for_crypt,host_address,msg,ping_quantity,msg_key)
        else:
            print("The parameters -k or -n or -m are not defined.")      
    #end