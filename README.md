![](images/PTBwideImage.jpeg)

# PIDtoolbox

PIDtoolbox is a set of graphical tools for analyzing blackbox log data for multirotors. It is available as a standalone program for Windows, Mac and Linux, and is tailored to work on Betaflight, Emuflight and INAV logfiles (see [**Download instructions**](https://github.com/bw1129/PIDtoolbox#download) below). For information on how to use the software, please visit the [**PIDtoolbox User Guide**](https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide) and subscribe to the [**The PIDtoolbox YouTube Channel**](https://www.youtube.com/channel/UCY2CVnWGEeRlyxOXVsHS_fA).

**If you would like 1-on-1 tuning consultation check out** 
### **[The PIDtoolbox Professional PID Tuning Service](https://pidtoolbox.com/)**

**If you'd like to support the PIDtoolbox project check out**
### **[The PIDtoolbox Patreon page](https://www.patreon.com/ThePIDtoolboxGuy)**    
### **[Make a PayPal donation](https://www.paypal.com/paypalme/PIDtoolbox)**
### **[Join the PIDtoolbox Discord](https://discord.gg/rHqhwpAXJH)**

![](images/PIDtoolbox_v0.32.png)

# Download

**<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">Download the latest version of PIDtoolbox.</a>** Unzip and place entire folder in a preferred location on your computer. For first time installation, use the **`MyAppInstaller_web`** file included in the package (under **`PIDtoolbox\runtime_installation_file\`**). **64 bit only!** This will install Matlab Runtime, which contains the standalone set of libraries that enables the execution of compiled MATLAB application. It's a fairly big download so hang in there :-) 

Once the installation is complete, the **`PIDtoolbox`** program is automatically placed under the program files or apps directory (in windows it's under **`C:\Program Files\PIDtoolbox\application`**), but a copy of the program file can also be found under **`PIDtoolbox\main\`** that you downloaded. Clicking either will start the program, but the shortcut that was created from the installation process links to the copy under the program files directory. I realize this may cause some confusion to have two copies of the same program but either should work fine, and as you update to later versions it is okay to keep old versions, and both will continue to function no problem. However, it's important to note that PIDtoolbox uses **`blackbox_decode`** which you can see along side the PIDtoolbox program (it's there in the main folder you downlaoded but also in the PIDtoolbox program files directory). The **`blackbox_decode`** program file should be placed anywhere your logfiles are placed; **it MUST to be in the same folder as the logfiles, and you can copy `blackbox_decode` multiple times all over your computer, that's fine. It doesn't take up much storage.** FYI, `Blackbox_decode` is part of the blackbox_tools software <a href="https://github.com/betaflight/blackbox-tools" target="blank">Betaflight/Cleanflight Blackbox Tools</a>, but that application is just conveniently packaged within this download. **Disclaimer**: Personally I've had no issue with placing my log files anywhere on my computer as long as blackbox_decode is in there with them, but in the interest of having less reported issues, it might sometimes be best to keep it next to the PIDtoolbox program and place logfiles in there, but feel free to experiment. 

There have been reports of PIDtoolbox hanging at different stages. If it hangs at the splash screen this may be indicative of the user rights and write access of the folder where PIDtoolbox is located. Right click on the `PIDtoolbox_vxx_win` folder and make sure it is NOT "read only" and that you have full rights to that folder. The same might apply to the program if used from the program files directory. It has also been noted that you should run PIDtoolbox as an administrator in Windows if possible. If instead PIDtoolbox hangs or gives an error message during loading of a logfile this is usually an issue with `blackbox_decode` described above (i.e., blackbox_decode is probably not in the folder of the logfile you're trying to open). I've also seen cases were logfiles with the same name but in different folders downstream of PIDtoolbox get confused by the program, so to avoid this try naming logfiles uniquely. Hopefully this solves some of the main reported issues. You can also look at the **Github Issues** reported here which have described some solutions to common problems. I requested that these issues remain posted to help future users.

**NOTE: if you already have a running version of PTB, you DON'T need to re-run the installer. Just grab the new PIDtoolbox program file and replace with your old version!**. In fact **never try to install Matlab runtime without the provided installer** because the version is critically linked to the program, and if you downloaded a different version of Runtime than the one in which PTB was compiled, it wont work. So if you had a working version of PIDtoolbox but then it stops working from some reason, I've never seen a case where reinstalling runtime resolved the issue, so that should be a last resort. When you download a new version of PTB, you can either remove the old executable `PIDtoolbox.exe` or `PIDtoolbox.app` and simply copy paste the new one in its place, or keep both in different folders. I.e.,  you may have multiple versions of the PIDtoolbox program on your computer. Both will run using the same Matlab Runtime that was installed during the original download. So whenever a new version of PTB appears, just download the `PIDtoolbox_vxx_win` or `PIDtoolbox_vxx_osc` folder and navigate to the `main` folder in there and run the program. That's all there is to it, no more downloading!!!

* PIDtoolbox has been confirmed to run on Windows7/8/10 64bit machines, and Mac 10.11 (El capitan), 10.13 (Sierra) and 10.14 (Mojave), and Linux. If you have issues installing Matlab runtime, or running PIDtoolbox, please post **<a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">feedback here</a>**, or post a response in the **<a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">Betaflight BlackBox Log Review Facebook group</a>** for Betaflight specific issues.

* For more advanced users, if you have Matlab and all the required toolboxes you can simply download the source code (download from the zip file on the **<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">releases</a>** page for the most up to date and platform-specific source code), and run from the command window. 


# Acknowledgments

Huge shout out to several people who contributed to this project outside GitHub. 
**Mark Spatz (UAVtech), Chris Thompson (ctzsnooze), Hugo Chiang (DusKing1), Qopter, Qratz, Zach Young, Zak Smiley, Stephen Wright, McGiverGim, Bizmar, Martin Hapl, Ken Kammerer, Paweł Spychalski, Christoph Herndler.** Thanks for your help!

 I hope you find PIDtoolbox useful, and I welcome feedback from the FPV community.

Cheers! -Brian
