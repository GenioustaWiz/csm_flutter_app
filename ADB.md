connecting my phone to adb wirelessly. run command: adb connect 192.168.0.101:35385

the ip adress is for my phone connected to same wifi as the computer

start nox emulator server, run this command: adb connect 127.0.0.1:62001
the ip address seems to work on all NOX Players, 
if already connected kill server first then connect again: adb kill-server