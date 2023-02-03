![](images/PTBwideImage.jpeg)

# PIDtoolbox

PIDtoolbox is a set of graphical tools for analyzing blackbox log data for multirotors. It is available as a standalone program for Windows, Mac and Linux, and is tailored to work on Betaflight, Emuflight and INAV logfiles (see [**Download instructions**](https://github.com/bw1129/PIDtoolbox#download) below). For information on how to use the software, please subscribe to the [**The PIDtoolbox YouTube Channel**](https://www.youtube.com/channel/UCY2CVnWGEeRlyxOXVsHS_fA).

### **If you use PIDtoolbox and would like it to continue, please consider supporting with a small donation. It goes a long way!**
* **[Make a PayPal donation](https://www.paypal.com/paypalme/PIDtoolbox)** 
* **[Become a Patreon](https://www.patreon.com/ThePIDtoolboxGuy)**    

**For 1-on-1 tuning consultation see [The PIDtoolbox Professional PID Tuning Service](https://pidtoolbox.com/)**

### **Other sources of info:**
* **[PIDtoolbox Facebook Page](https://www.facebook.com/ThePIDtoolboxGuy)**
* **[PIDtoolbox Discord](https://discord.gg/rHqhwpAXJH)**
* **[PIDtoolbox YouTube Channel](https://www.youtube.com/channel/UCY2CVnWGEeRlyxOXVsHS_fA)**

# Download

**<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">Download the latest version of PIDtoolbox.</a>** Unzip and place entire folder in a preferred location on your computer. For first time installation, use the **`MyAppInstaller_web`** file included in the package (under **`PIDtoolbox\installer\`**). This will install Matlab Runtime, which contains the standalone set of libraries that enables the execution of compiled MATLAB application. As newer version are released, there may be new and different installation steps, and these will be placed in the release notes for that version, as well as links to YouTube vids to help the process, so pay attention to that. 

Once the installation is complete, the **`PIDtoolbox`** program is automatically placed under the program files or apps directory, but a copy of the program file can also be found in the folder you downloaded **`PIDtoolbox\main\`**, and you should use the one in this 'main' folder.

**NOTE: if you already have a running version of PTB, you typically don't need to re-run the installer, but if the program does not run, you can try reinstalling. BUT, **never try to install Matlab runtime without the provided installer** because the version is critically linked to the program, and if you downloaded a different version of Runtime than the one in which PTB was compiled, it wont work. When you download a new version of PTB, you can either remove the old executable `PIDtoolbox.exe` or `PIDtoolbox.app` and simply copy paste the new one in its place, or keep both in different folders. I.e.,  you may have multiple versions of the PIDtoolbox program on your computer. Both will run using the same Matlab Runtime that was installed during the original download.
