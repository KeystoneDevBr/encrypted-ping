
# How To Send Encrypted Message With ICMP (ping)  Protocol.

## The Advanced Example of The Shell Script Dialog with Python3

## How does it Work 

This app send messages in the boby of the ICMP packeges echo-resquest and echo-replay.

This messages can be send in clear text or cryptografed with SHA256.


![](./imags/index.png)

![](./imags/send-menu.png)

![](./imags/send-sniff.png)

![](./imags/send-sniff2.png)

![](./imags/send-sniff3.png)

![](./imags/send-sniff4.png)


# How to Install it
## The Basics packages and the App need to be Installed in the both servers (Sender and receiver)

```
sudo apt install dialog
sudo apt install zip

# You need install python 3.10
# Try somethin like this
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt update
    sudo apt install python3.10 -y # You can install latest version
    python3 --version

# You need install pip
    sudo apt install python3-pip

# You need install python Scapy library 
# The installation guite is avaliable in: htts://www.scapy.net
# If python was instaled before, Tray something like this
    sudo pip install --pre scapy[complete]

# You need install Crypt.Cyper python libre
#Try something lik this
    sudo pip install pycrypto

```

 
### Download the files and extract it
```

wget https://github.com/KeystoneDevBr/encrypted-ping/archive/refs/heads/main.zip

unzip main.zip 

mv encrypted-ping-main/ ./encrypted-ping/

```

### Change file permissions

```
#Grant executable permission
sudo chmod 775 -R ./encrypted-ping/

#Check the app files
cd ./encrypted-ping/

#Show files
ls -1 ./encrypted-ping/

# You need see something like this:
# ./encrypted-ping/ 
#            README.md
#            f_information.sh
#            f_seng_ping.sh
#            f_sniff_ping.sh
#            icmp-receive.py
#            icmp-send.py
#           imags
#            index.sh
```

## Check python  files (sender and reciver files)

The files icmp-send.py and icmp-receive.py are reponsible for sending and receiving messages. 

### Step 1: Try send and receive clear messages


Star the sniffer in the receiver server (192.168.30.1)

```
# Execute the sniffer in backgroud until the first package received
sudo python3 ./encrypted-ping/icmp-receive.py  -c n -a 192.168.30.5 &

# Watch the file message
watch -n 0.1 "cat /tmp/msg_uncrypted.txt"


```

Send  message in the sender server (19.168.30.1)

```
sudo python3 ./encrypted-ping/icmp-send.py -c n -a 192.168.30.5 -m "Clear Message to Send" -q 4

```

#### Step 2: try send an receive crypted messages


Star the sniffer in the receiver server (192.168.30.5)
```
# Execute the sniffer in backgroud until the first package received
sudo python3 ./encrypted-ping/icmp-receive.py  -c y -k "key" -a 192.168.30.1 &
# Watch the file message
watch -n 0.1 "cat /tmp/msg_decrypted.txt"


```

Send  message in the sender server (19.168.30.5)

```
sudo python3 ./encrypted-ping/icmp-send.py -cy -k "key" -a 192.168.30.1 -m "Crypted Message to Send" -q 4

```

### Start the APP

```
sudo ./encrypted-ping/index.sh

```

