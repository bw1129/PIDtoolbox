![](images/PTBwideImage.jpeg)

# PIDtoolbox

PIDtoolbox is a set of graphical tools for analyzing blackbox log data for multirotors. It is available as a standalone program for Windows, Mac and Linux, and is tailored to work on Betaflight, Emuflight and INAV logfiles (see [**Download instructions**](https://github.com/bw1129/PIDtoolbox#download) below). For information on how to use the software, please subscribe to the [**The PIDtoolbox YouTube Channel**](https://www.youtube.com/channel/UCY2CVnWGEeRlyxOXVsHS_fA).

**If you use PIDtoolbox and would like it to continue, please consider supporting with a small donation. It goes a long way!**
-**[PayPal donation](https://www.paypal.com/paypalme/PIDtoolbox)** 
-**[Become a Patreon](https://www.patreon.com/ThePIDtoolboxGuy)**    

**For 1-on-1 tuning consultation see [The PIDtoolbox Professional PID Tuning Service](https://pidtoolbox.com/)**

**[Join the PIDtoolbox Discord](https://discord.gg/rHqhwpAXJH)**

# Download

**<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">Download the latest version of PIDtoolbox.</a>** Unzip and place entire folder in a preferred location on your computer. For first time installation, use the **`MyAppInstaller_web`** file included in the package (under **`PIDtoolbox\runtime_installation_file\`**). **64 bit only!** This will install Matlab Runtime, which contains the standalone set of libraries that enables the execution of compiled MATLAB application. It's a fairly big download so hang in there :-) 

Once the installation is complete, the **`PIDtoolbox`** program is automatically placed under the program files or apps directory (in windows it's under **`C:\Program Files\PIDtoolbox\application`**), but a copy of the program file can also be found under **`PIDtoolbox\main\`** that you downloaded. Clicking either will start the program, but the shortcut that was created from the installation process links to the copy under the program files directory. I realize this may cause some confusion to have two copies of the same program but either should work fine, and as you update to later versions it is okay to keep old versions, and both will continue to function no problem. However, it's important to note that PIDtoolbox uses **`blackbox_decode`** which you can see along side the PIDtoolbox program (it's there in the main folder you downlaoded but also in the PIDtoolbox program files directory). FYI, `Blackbox_decode` is part of the blackbox_tools software <a href="https://github.com/betaflight/blackbox-tools" target="blank">Betaflight/Cleanflight Blackbox Tools</a>, but that application is just conveniently packaged within this download.

**NOTE: if you already have a running version of PTB, you DON'T need to re-run the installer. Just grab the new PIDtoolbox program file and replace with your old version!**. In fact **never try to install Matlab runtime without the provided installer** because the version is critically linked to the program, and if you downloaded a different version of Runtime than the one in which PTB was compiled, it wont work. So if you had a working version of PIDtoolbox but then it stops working from some reason, I've never seen a case where reinstalling runtime resolved the issue, so that should be a last resort. When you download a new version of PTB, you can either remove the old executable `PIDtoolbox.exe` or `PIDtoolbox.app` and simply copy paste the new one in its place, or keep both in different folders. I.e.,  you may have multiple versions of the PIDtoolbox program on your computer. Both will run using the same Matlab Runtime that was installed during the original download. So whenever a new version of PTB appears, just download the `PIDtoolbox_vxx_win` or `PIDtoolbox_vxx_osc` folder and navigate to the `main` folder in there and run the program. That's all there is to it, no more downloading!!!

* PIDtoolbox has been confirmed to run on Windows7/8/10 64bit machines, and Mac 10.11 (El capitan), 10.13 (Sierra) and 10.14 (Mojave), and Linux. If you have issues installing Matlab runtime, or running PIDtoolbox, please post **<a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">feedback here</a>**, or post a response in the **<a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">Betaflight BlackBox Log Review Facebook group</a>** for Betaflight specific issues.

* For more advanced users, if you have Matlab and all the required toolboxes you can simply download the source code (download from the zip file on the **<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">releases</a>** page for the most up to date and platform-specific source code), and run from the command window. 
