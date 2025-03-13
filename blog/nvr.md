+++
date = "2025-03-13"
rss = "In this technical guide, I document my process of building a reliable NVR system using a LePotato board, inexpensive IP cameras, and Frigate software. The setup involves configuring headless SSH access to the board using arch-chroot, establishing static IP addresses for cameras outside the DHCP range, testing RTSP streams via VLC, and deploying Frigate through Podman with hardware acceleration."
tags = ["pi"]
+++

# NVR with PI that makes sense

Around five years ago, while on vacation in Latvia during my PhD studies, I experienced a moment that would eventually lead me down the path of DIY home surveillance. My mom received a call from someone conducting a survey about internet-connected devices in our home. As she happily listed off our tablets, TVs, computers, and surveillance cameras to this complete stranger, I was struck with horror at the potential security implications.

At that time, I owned a Raspberry Pi that I had configured as network-attached storage (NAS) using Resilio Sync. Setting it up with cameras seemed like too much work on short notice, so I opted for the convenience of Nooie cameras instead. They were simple to set up—just insert a micro SD card for loop recording—and the video quality met my needs perfectly for several years.

Unfortunately, Nooie began pushing their cloud subscription more aggressively over time. With each software update, the SD cards seemed to fail more frequently. The final straw came when they removed the loop recording option from their mobile app entirely, rendering the cameras useless as a reliable security solution.

This frustrating experience pushed me to explore more dependable alternatives. I began experimenting with a BrillCam connected to a LePotato (a Raspberry Pi clone) running MotionEyeOS as my Network Video Recorder (NVR). While this setup worked, the interface was clunky and unresponsive. Despite these issues, I let it run for about six months until the micro SD card eventually failed.

Last month, I decided to tackle this problem once and for all by creating a proper NVR server using inexpensive IP cameras from AliExpress. After some research, I discovered Frigate—an NVR solution I had initially dismissed for being Python-based and potentially slow. However, its fluid TypeScript UI and excellent ergonomics completely changed my mind. While the setup required manual configuration, with Claude's assistance, I was able to configure Frigate exactly as needed and found out new workflow hacks. To not miss those steps, this blog post is written as a reference for the future.

## Setting up LePotato

I thought I had mastered setting up Raspberry Pi and LePotato from my previous years of use, and I did not anticipate that my familiar workflow would be completely challenged. I spent 2 days just to get SSH access to my headless server as I adjusted to the passwordless ssh setup workflow. It is fairly simple to set up with Raspberry Pi Imager, which provides UI for that, but that did not work for my LePotato.  Also, relying on it would devalue all Raspberry Pi alternatives I could get my hands on, and hence I was looking for more generic workflows.

I remembered that I have had a good experience with `chroot` recovering the systems with raspberry pi for my NAS setup, but it was a bit clumsy to use. Now, thanks to Claude, I learned about `arch-chroot` command, which makes the experience seamless. After writing the OS image into my SD card and mounting the root file system, I do the following:

```
sudo arch-chroot .
```

which enters me into root shell from which I can do set up a login:

```
useradd -m -s /bin/bash pi3
passwd pi3 # sets up password
usermod -aG sudo pi3
```

The beauty of this approach is that I can always return to this command at any time my ssh breaks down, giving me peace of mind.

SSH is already enabled on the Ubuntu server, so I did not need to bother with enabling it in `etc/ssh/sshd_config`. What is needed to do so is to list public keys of hosts that can access the server. This can be done with a setup:

```
mkdir -p /home/pi3/.ssh
chmod 700 /home/pi3/.ssh
nano /home/pi3/.ssh/authorized_keys # paste ssh public keys here
chmod 600 /home/pi3/.ssh/authorized_keys
chown -R pi3:pi3 /home/pi3/.ssh
```

At this point, the SD card can be inserted into the mini server, and SSH would work just fine.

To discover the IP address of the server, we shall scan the subnet that is responsible for advertising DHCP. We can do so with:

``` 
nmap -sn 192.168.1.0/24
```

where `/24` represents the first 24 bits of the subnet. There is also a nice command `ip neighbour` and `arp -a`, which can be used for the discovery.

After the discovery, I recommend linking the server MAC address to a static IP address within the router. This offers the nice benefit of being able to still connect the mini pc within different networks without encoding assumption on the subnet which system is. 

## Setting up Cameras

The IP cameras are often configured with a static IP address written on the sticker attached to the camera. To connect to the camera, your computer needs to be on the same subnet; otherwise, the requests are routed to the outside internet. (I learned this painfully by wasting another two days on this as I had forgotten this crucial detail.)

When connecting directly with the computer, through the switch, even with a present router one sets up:

```
Address: 192.168.8.1
Netmask: 255.255.255.0
```

The gateway is optional and could be set as `192.168.8.1`, which can allow the  IP camera to access the internet through the host computer (I haven't tested that).

After connecting the cameras, one can set their IP addresses to match the local network's subnet. I generally prefer to change my subnet to prevent forgetting the subnet I left my IP camera in. A recovery strategy would then be to set the Netmask to `255.255.0.0` and do the scan with `nmap —sn 192.168.1.0/16`. 

There is also an option to use DHCP for the cameras. This can be a good option if one has a robust router and can keep a backup of MAC/IP address linking. However, I would advise against doing so for most consumer routers, as it can make internet router resets painful. Note that static IP addresses should be outside the DHCP range, which may need to be adjusted within your router. 

The final step is finding the RTSP stream of the camera. For my AliExpress cheap camera that happens to be in:

```
rtsp://admin:123456@192.168.1.11/stream1
```

You can test it with VLC, checking that it displays the video. Note that on Ubuntu, VLC no longer comes with RTSP support by default. However, you can still install it from Flatpak and get it back.

## Installing Frigate

The Frigate recommends using docker for the setup. I had heard good reviews on the internet about `podman` written in Rust and offers better containerization for security. To install it, one does:

```
sudo apt install podman
sudo apt install uidmap
```

To start the Frigate, we need to configure it with `config.yml`. LLM can effectively write this, so I will not paste my full configuration here. I note that on LePotato, I have managed to use the following options:

```
ffmpeg:
  hwaccel_args: preset-rpi-64-h264
```

for video acceleration. 

The next step is to create a place for Frigate files, for instance, `~/frigate` where the `config.yml` is specified and start the frigate service as:

```  
podman run -d   --name frigate   --shm-size=768mb   --network=host   --device=/dev/video0:/dev/video0   --group-add video   -v $HOME/frigate:/config:Z   -v $HOME/frigate/cache:/tmp/cache:Z -v $HOME/frigate/store:/media/frigate:Z   ghcr.io/blakeblackshear/frigate:stable
```

Note that we assume the user is part of `video` group, which can be added with:

```
sudo usermod -aG video $USER
```

This will download frigate and start the service with a name `frigate`. 

We can check what the service is doing with:

```
podman logs frigate
```

To restart it, we remove it with `podman rm -f frigate` and repeat the `podman` command. 

If this step is successful, the Frigate can be accessed via `http://192.168.1.2:5000`. With the next step, we shall make the service permanent using `systemd` to start it automatically at login and restart it if it is killed.

## Systemd

When a frigate is launched, it also conveniently creates a `frigate/container-frigate.service` file that we can use to register with Systemd. We shall register it at the userspace via:

```
podman generate systemd --name frigate > container-frigate.service
mkdir -p ~/.config/systemd/user/
ln -sf /home/pi3/frigate/container-frigate.service ~/.config/systemd/user/
```

Then reload the cache to make Systemd pick it up:

```
systemctl --user daemon-reload
```

We can then enable the service to start at login:

```
systemctl --user enable container-frigate.service
loginctl enable-linger $USER # may be needed
```

and start it immediately with `systemctl --user start container-frigate.service`. 

When debugging, it is convenient to use `podman` commands like `podman logs frigate` to see what is happening and do so at the podman level. Meanwhile, for it to not interfere with debugging, one simply stops the service:

```
systemctl --user stop container-frigate.service`
```

## What's next?

My LePotato has been running frigate for the past two weeks with quite some success. The web interface is snappy and effortless to use and allows me to review history quickly. I am now in the process of connecting the HDD to the PI so that I do not trash my SD card, and I plan to add UPS for backup power in the future. There is also an option to set up a rather good human detection on Frigate using a Coral AI accelerator card, which I may explore in the near future.
