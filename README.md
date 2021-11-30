
# PIDtoolbox

**PIDtoolbox** is a set of graphical tools for analyzing blackbox log data for multirotors. It is available as a standalone program for Windows, Mac and Linux, and is tailored to work on Betaflight, Emuflight and INAV logfiles. 
* [**Download instructions**](https://github.com/bw1129/PIDtoolbox#download).

* [**PIDtoolbox User Guide**](https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide).

* **If you would like 1-on-1 tuning consultation please visit <a href="https://github.com/bw1129/PIDtoolbox/wiki/Professional Tuning Service" target="blank">The Tuning Service Page</a>**

* **If you'd just like to ask a technical question about the software, tuning or troubleshooting, or you just wanna donate to the project, drop me a [donation](https://www.paypal.com/donate/?business=EMCJRU9M7AKAA&currency_code=CAD) then direct message me in Facebook messenger ([the PIDtoolbox guy on speed dial](https://www.facebook.com/ThePIDtoolboxGuy))**

![](images/PIDtoolbox_v0.32.png)

# Download

**<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">Download the latest version of PIDtoolbox.</a>** Unzip and place entire folder in a preferred location on your computer. For first time installation, use the **`MyAppInstaller_web`** file included in the package (under **`PIDtoolbox\runtime_installation_file\`**). **64 bit only!** This will install Matlab Runtime, which contains the standalone set of libraries that enables the execution of compiled MATLAB application. It's a fairly big download so hang in there :-) 

Once the installation is complete, the **`PIDtoolbox`** program is automatically placed under the program files or apps directory (in windows it's under **`C:\Program Files\PIDtoolbox\application`**), but a copy of the program file can also be found under **`PIDtoolbox\main\`** that you downloaded. Clicking either will start the program, but the shortcut that was created from the installation process links to the copy under the program files directory. I realize this may cause some confusion to have two copies of the same program but either should work fine, and as you update to later versions it is okay to keep old versions, and both will continue to function no problem. However, it's important to note that PIDtoolbox uses **`blackbox_decode`** which you can see along side the PIDtoolbox program (it's there in the main folder you downlaoded but also in the PIDtoolbox program files directory). The **`blackbox_decode`** program file should be placed anywhere your logfiles are placed; **it MUST to be in the same folder as the logfiles, and you can copy `blackbox_decode` multiple times all over your computer, that's fine. It doesn't take up much storage.** FYI, `Blackbox_decode` is part of the blackbox_tools software <a href="https://github.com/betaflight/blackbox-tools" target="blank">Betaflight/Cleanflight Blackbox Tools</a>, but that application is just conveniently packaged within this download. **Disclaimer**: Personally I've had no issue with placing my log files anywhere on my computer as long as blackbox_decode is in there with them, but in the interest of having less reported issues, it might sometimes be best to keep it next to the PIDtoolbox program and place logfiles in there, but feel free to experiment. 

There have been reports of PIDtoolbox hanging at different stages. If it hangs at the splash screen this may be indicative of the user rights and write access of the folder where PIDtoolbox is located. Right click on the `PIDtoolbox_vxx_win` folder and make sure it is NOT "read only" and that you have full rights to that folder. The same might apply to the program if used from the program files directory. It has also been noted that you should run PIDtoolbox as an administrator in Windows if possible. If instead PIDtoolbox hangs or gives an error message during loading of a logfile this is usually an issue with `blackbox_decode` described above (i.e., blackbox_decode is probably not in the folder of the logfile you're trying to open). I've also seen cases were logfiles with the same name but in different folders downstream of PIDtoolbox get confused by the program, so to avoid this try naming logfiles uniquely. Hopefully this solves some of the main reported issues. You can also look at the **Github Issues** reported here which have described some solutions to common problems. I requested that these issues remain posted to help future users.

**NOTE: if you already have a running version of PTB, you DON'T need to re-run the installer. Just grab the new PIDtoolbox program file and replace with your old version!**. In fact **never try to install Matlab runtime without the provided installer** because the version is critically linked to the program, and if you downloaded a different version of Runtime than the one in which PTB was compiled, it wont work. So if you had a working version of PIDtoolbox but then it stops working from some reason, I've never seen a case where reinstalling runtime resolved the issue, so that should be a last resort. When you download a new version of PTB, you can either remove the old executable `PIDtoolbox.exe` or `PIDtoolbox.app` and simply copy paste the new one in its place, or keep both in different folders. I.e.,  you may have multiple versions of the PIDtoolbox program on your computer. Both will run using the same Matlab Runtime that was installed during the original download. So whenever a new version of PTB appears, just download the `PIDtoolbox_vxx_win` or `PIDtoolbox_vxx_osc` folder and navigate to the `main` folder in there and run the program. That's all there is to it, no more downloading!!!

* PIDtoolbox has been confirmed to run on Windows7/8/10 64bit machines, and Mac 10.11 (El capitan), 10.13 (Sierra) and 10.14 (Mojave), and Linux. If you have issues installing Matlab runtime, or running PIDtoolbox, please post **<a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">feedback here</a>**, or post a response in the **<a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">Betaflight BlackBox Log Review Facebook group</a>** for Betaflight specific issues.

* For more advanced users, if you have Matlab and all the required toolboxes you can simply download the source code (download from the zip file on the **<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">releases</a>** page for the most up to date and platform-specific source code), and run from the command window. 


# Quick Guide

For a detailed guide to PIDtoolbox, please visit the **<a href="https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide" target="blank">PIDtoolbox Wiki page</a>**.

For a quick guide, follow the steps below:

**(i)** **<a href="https://github.com/bw1129/PIDtoolbox/releases" target="blank">PIDtoolbox</a>** reads **`.bbl`** or **`.bfl`** files directly by decoding them using **`blackbox_decode`** <a href="https://github.com/betaflight/blackbox-tools" target="blank">(Betaflight/Cleanflight Blackbox Tools)</a>, which is conveniently packaged within the PIDtoolbox download. Just place your **`.bbl`** or **`.bfl`** files right in the main folder where the **`PIDtoolbox`** and **`blackbox_decode`** program files are already located. Start the program, select the file(s) you wish to load by clicking the **`select file(s)`** button. NOTE: the Mac version does not show a "splash screen" when you run the program (an issue with Matlab for Mac), so it may seem like nothing is happening, but please be patient while it to loads.

**(ii)** It is recommended to log at 2k (unless you're running 1k loop rate in which case log at 1k), because the spectrograms only go to 1k. It is not recommended to log higher than 4k. It'll run, but much slower.

**(iii)** It is recommended that you set debug mode to **`GYRO_SCALED`** for PIDtoolbox. This is because the program expects the debug variables to contain the unfiltered gyro data, which is used to plot the filtered vs unfiltered gyro spectrograms, and compute gyro phase latency online. Be aware that the debug mode you choose will result in different data contained in the 'gyro unfiltered' variable. For a list of debug modes and the data contained in the debug variable, see the **<a href="https://github.com/betaflight/betaflight/wiki/Debug-Modes" target="blank">Betaflight debug modes wiki</a>**.

If you have issues installing Matlab Runtime, or running PIDtoolbox, please post **<a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">feedback here</a>**, or post a response in the **<a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">Betaflight BlackBox Log Review Facebook group</a>**.

* ***Linux users:*** 
The latest working version for Linux users is v0.392. In most cases you'll have to run PTB from the command terminal, so navigate to the `main` PIDtoolbox folder from the command prompt and execute **`./run_PIDtoolbox.sh`**. You can try double clicking the **'run_PIDtoolbox.sh'** icon directly in the `main` folder (not the PIDtoolbox icon). If it doesn't work, run via the command prompt AND provide the path of the runtime installation as an argument:	e.g. **`[[./run_PIDtoolbox.sh]] /opt/matlab/matlab_runtime/v93`**. (Many thanks to **<a href="https://github.com/ghostface" target="blank">Christoph Herndler (Ghostface)</a>** for helping get PTB for Linux working and providing these details!). 

# Acknowledgments

Huge shout out to several people who contributed to this project outside GitHub. 
**Mark Spatz (UAVtech), Chris Thompson (ctzsnooze), Hugo Chiang (DusKing1), Qopter, Qratz, Zach Young, Zak Smiley, Stephen Wright, McGiverGim, Bizmar, Martin Hapl, Ken Kammerer, Paweł Spychalski, Christoph Herndler.** Thanks for your help!

 I hope you find PIDtoolbox useful, and I welcome feedback from the FPV community.

Cheers! -Brian
