+++
date = "2017-02-25"
tags = ["linux", "bash", "cron"]
rss = "Dropbox offers a great alternative to hosting your own SAMBA server and provides a stable and user-friendly experience, but the space limitations without a subscription plan and being into vendor lock-in led me to the search for alternatives. Eventually, I found hope in the BitTorrent Sync technology, which allows limitless storage and fast data sharing without relying on cloud storage. Here I show my setup with Raspberries using BitTorrent Sync and how I have configured it with an RClone cron job to synchronise with the cloud."
+++

# From a cloud to a personalized edge 

I have been a Dropbox user for a long time and can recommend it for its stability and ease of use. But it comes with its tradeoffs - the space is limited until you subscribe to their service. That felt too expensive or me, and I started to look for alternatives this April, mainly what I could do with my raspberry pi and home ethernet connection.

Hosting my own data storage service like SAMBA or OwnCloud is hard. First, I do not have a static IP address to which I could always connect, which can be subscribed for an additional fee from my ethernet
provider. Also, my network connection is not fast enough to upload data (about 200 kb/s), so large data storage and management seemed painful. Thus costs for subscribing to Dropbox are actually reasonable costs compared to your own effort to maintain a similar service.

Hope came when I read about BitTorrent Sync technology. It allows for making synchronisation folders which can be shared between computers (also phones) without the use of cloud storage. That, in turn, offers limitless storage and speed for sharing data. That is such marvellous software to use! Thus although property (Syncthing is a promising open-source alternative) I decided to dive into it.

## Setting up raspbian

Since data is not stored on the cloud, for synchronising, at least two computers must be on. That is usually inconvenient; thus, like others, I set my own always-on node on raspberry pi. Since every time when I set up new stuff on raspberry pi, I look for the same commands on the Internet, I decided to make a detailed description for that here. I start with raspberry pi and an SD card.

On the computer, I download raspbian lite and make a burn to the SD card
with a command

```bash
dd bs=4M if=2017-07-05-raspbian-jessie.img of=/dev/sdX
```
where X can be found from changes in `ls /dev`. After that, I create `/boot/ssh` file to enable listening for ssh connections for this one session (the ssh file is deleted on boot). Then I push my SD card into Pi and attach it to my computer with an ethernet cable with the method "Shared to other computers" under "Network Connections". The IP address can be found with

```bash
nmap -n -sP 10.42.0.255
```
where the last number is Broadcast Address, which can be found under connection information. Another way is to scan the whole local network with the following command:

```bash
nmap -sP 192.168.1.1/24
```
Now I am able to connect to pi over ssh:
```bash
ssh pi@10.42.0.240
```
where the number is the IP address of the previous step (password is Raspberry). As a first step, I change the password with `passwd` command. Then I start
`raspi-config` and do the following actions in the menu

-   increase partition size to occupy all SD card
-   Enable ssh on boot

Now Raspberry is set up for configuration.

## Finding ip ADDRESS by an email message

My internet provider provides me with a public IP address allowing me to configure it outside my home network and other exciting things like personal VPN, Samba server, etc. However, it is not static; thus, I have to keep track of it somehow. I have chosen to use email to do that.

As usual, I spent a long time looking for information for things not possible (it was!!!) - sending an email directly from the IP address to Gmail. As a remedy, I have to use an authorised (in some way to avoid spam) email also to send messages which require me to store my email password on the device. That is done by SMTP, and the message script in Python looks
as follows:

```
#!/usr/bin/python
import subprocess
import smtplib
import socket
from email.mime.text import MIMEText
import datetime
# Change to your own account information
to = 'akels14@gmail.com'
gmail_user = 'akels14@gmail.com'
gmail_password = '*********'
smtpserver = smtplib.SMTP('smtp.gmail.com', 587)
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.ehlo
smtpserver.login(gmail_user, gmail_password)
today = datetime.date.today()
# Very Linux Specific
arg='ip route list'
p=subprocess.Popen(arg,shell=True,stdout=subprocess.PIPE)
data = p.communicate()
split_data = data[0].split()
ipaddr = split_data[split_data.index('src')+1]
my_ip = 'Your ip is %s' %  ipaddr
msg = MIMEText(my_ip)
msg['Subject'] = 'IP For RaspberryPi on %s' % today.strftime('%b %d %Y')
msg['From'] = gmail_user
msg['To'] = to
smtpserver.sendmail(gmail_user, [to], msg.as_string())
smtpserver.quit()
```
To run this script on boot, I put it in `/home/pi/bin` with `chmod +x` and add the following lines to `/etc/rc.local`

```bash
IP=$(hostname -I) || true
    if [ "$_IP" ]; then
      printf "My IP address is %s\n" "$_IP"
      sleep 30
      sudo -u pi -i mailip
    fi
```
That will execute the script after all other Linux scripts are done. Sometimes I did not receive emails; thus, one needs to set up raspberry to wait for the network until the boot is finished, which is available under `raspi-config`. Another option is to execute the script when a network connection is established. That can be accomplished by putting the script in `/etc/network/if-up.d/mailip`. However, that did not work for me.

## Configuration of bittorrent sync

On the Internet, I have read opinions that BitTorrent sync 1.4 is the last stable version, which works best with old raspberry pi, which I did use. Also, the GUI client on Linux has not indicator applet on newer Linux versions, as development seems to be stalled. Fortunately, after
looking for an hour, I found it on [BitTorrent Sync PPA](https://launchpad.net/~tuxpoldo/\+archive/ubuntu/btsync).

The arm archive downloaded in the link needs to be unarchived and placed and synced to the raspberry pi, which can be done with a command:

```bash
rsync btsync pi@[ip pi]:~/bin/
```
It also needs to be started on boot which can be done by placing a line before `exit 0` in `/etc/rc.local`:

```bash
sudo -u pi -i nohup btsync --webui.listen 0.0.0.0:8888 &
```
To log in to the btsync in the browser, the following address must be used:
```bash
[ip of pi]:8888/gui/
```
In there, you can either create or attach yourself to the shares. And that's it. You may now restart the device, and it will still work as a cloud
for you.

## Mirroring with cloud

After I had used this setup for over a month, I found it to be very robust and
also faster in synchronising than Drobox. The problem at present is that almost no one uses it if you compare the userbase of Dropbox, Onedrive and Google Drive. That, in turn, adds complexity where my pc may fail and makes it feel crowded. I decided that a better option is to put the synchronisation of various cloud services on my Raspberry.

As it turned out, that was not straightforward. For example, Dropbox client does not work on arm devices, and there are no plans to support them. A far-fetched option was to emulate it with a desktop, which worked in principle but was unbearably slow.

Fortunately, there is a `rclone` cloud synchronisation command line application inspired by the `rsync`. Although it does its task great of making rsync-like data transfers, it was not immediately apparent how I could make synchronisation of this one. It took me days (or weeks) until I found a way with `union-fuse`.

First, I create three folders, for example, dropbox:
```bash
mkdir -p ~/Cloud/Dropbox.diff
mkdir -p ~/Cloud/Dropbox.ro
mkdir -p ~/BtSync/Cloud/Dropbox 
```
Then with `unionfs`, I bind them together into `/etc/rc.local` (again before
exit 0)

```bash
sudo -u pi -i nohup unionfs-fuse -o cow Cloud/Dropbox.diff=RW:Cloud/Dropbox.ro=RO BtSync/Cloud/Dropbox &
```
where union-fuse must be installed with `sudo apt-get install union-fuse`. This command now will merge not intended to be written folder `Dropbox.ro` with differences `Dropbox.diff` to form an ordinary Dropbox folder, which is synchronised over the network with `btsync`. What
remains to be done is to push changes from `Dropbox.diff` to the cloud and synchronise `Dropbox.ro` with it. That is exactly what I am doing.

To use `rclone` on pi I downloaded the [RClone binary](https://rclone.org/downloads/) for arm devices and put it in `~/bin` on pi:

```bash
rsync rclone pi@[ip of pi]:~/bin/
```
Then I ssh on the pi, run `rclone config` and follow instructions to add remote like Dropbox. To test my remote, I mirror the cloud locally with a command:

```bash
rclone sync Dropbox: ~/Cloud/Dropbox.ro
```
The last step is to put `rclone` and union-fuse together to form a synchronisation. The hardest part was to ensure that deletes remotely or locally took effect. Otherwise, the synchronisation script is simple:

```bash
#!/bin/bash
# The script which applies the changes from unionfs and pulls new data from cloud
Remote=$1 # Dropbox
BaseDir=$HOME/Cloud/$Remote
mkdir -p $BaseDir.ro && mkdir -p $BaseDir.diff

if test "$(ls -A $BaseDir.diff)"; then # A better option would be to use find to eclude sync files 
    mkdir -p $BaseDir.diff/.unionfs && cd $BaseDir.diff/.unionfs || exit 1
    find . -name "*_HIDDEN~" -type f | while read file; do rm "$file" && rm "$BaseDir.ro/${file:0:-8}" && rclone delete $Remote:"${file:0:-8}"; done
    find . -name "*_HIDDEN~" -type d | while read dir; do rmdir "$dir" && rmdir "$BaseDir.ro/${dir:0:-8}" && rclone rmdir $Remote:"${dir:0:-8}"; done 

    cd $BaseDir.diff || exit 1

    rsync -ua --exclude "*.!sync" --exclude ".unionfs" . "$BaseDir.ro"
    rclone move -u --delete-after --exclude "*.!sync" --exclude ".unionfs" . $Remote:

    find . -type d ! -name "*_HIDDEN~" -empty -delete
fi    

rclone sync $Remote: $BaseDir.ro
exit 0
```
which I place under `~/bin/rclone-bisync` with usual `chmod +x`.

The last step is to execute this script regularly, which I do with crontab. That works as follows. I ssh into Raspberry and execute `crontab -e,` which lets me edit the user's crontab file. In that, I put the following line:

```plaintext
* * * * * sudo -u pi -i flock -n Dropbox.lock rclone-bisync Dropbox
```
which ensures that synchronisation is being started every minute if it is not already running. But for this to be effective system must log in to the user; thus, I set up autologin with `raspi-config`. Another option is to edit the system's crontab with `sudo crontab -e,` which would not need
autologin.
