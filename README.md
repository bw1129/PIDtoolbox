
# PIDtoolbox

PIDtoolbox is a Matlab-based GUI for analyzing Betaflight blackbox log files for multirotors.

![](images/PT0.2logviewer.png)

The motivation for the development of this tool was to create a user-friendly GUI for analyzing blackbox data, using a high-level language with simple plotting and visualization tools that are more accessible to a larger part of the FPV community. A second goal was to develop an objective method for comparing between flights. It was inspired by the way we often troubleshoot flight performance issues (e.g., vibrations, mid-throttle oscillation, propwash), where we make back to back test flights with slight changes in software/hardware/mechanical settings with each test, and then make subjective inferences about flight performance. The problem is subjective bias becomes a real issue when the differences between tests are subtle. PIDtoolbox was designed with this in mind.

PIDtoolbox v0.2 is aimed at being a full "one stop shop" set of blackbox analyses tools centered around the main interests/issues of multirotor pilots. Version 0.2 features an extensive data log viewer, four independent multi-variable spectral analyzers, as well as step response and pid error analyses tools. Below is everything you need to begin using PIDtoolbox. I hope you find it useful, and I welcome feedback from the FPV community.

-Brian

# Download

There are a couple of ways you can download PIDtoolbox. 

**1)** If you have Matlab, you can simply download the repository of mfiles, place them in a folder, and run `PIDtoolbox.m` from the Matlab command prompt. You will need several toolboxes installed for this to work (control toolbox, signal processing toolbox, image processing toolbox and statistics toolbox). I am also working on converting the code to run in <a href="https://www.gnu.org/software/octave/" target="blank">Octave</a>, a free high-level programming platform that was designed to be largely compatible with Matlab (thanks <a href="https://www.facebook.com/UAVTech1/" target="blank">Mark Spatz</a> for bringing this to my attention!).  

**2)** If you do not have Matlab (or Octave), you can download a standalone Windows version of PIDtoolbox. You must first install Matlab runtime (MATLAB® Compiler Runtime, MCR), which then allows you to run any standalone Matlab program.

- **(i)** Install Matlab runtime <a href="https://www.mathworks.com/products/compiler/matlab-runtime.html" target="blank">(Matlab-runtime)</a> for Windows **(64bit only, version 9.3 R2017b**; it will not work on 32bit machines). A `runtime install file` is also included in the <a href="https://github.com/bw1129/PIDtoolbox/releases/tag/v0.2" target="blank">PIDtoolbox v0.2 package</a>. The good news is this is a one-time installation, after which you can run any Matlab standalone! If you have already been running a previous version of `PIDtoolbox`, you do not need to reinstall runtime, but I would recommend deleting the old version of `PIDtoolbox` and its contents before running the latest version. 

- **(ii)** Download the latest version of <a href="https://github.com/bw1129/PIDtoolbox/releases/tag/v0.2" target="blank">PIDtoolbox (v0.2)</a> for Windows. Unzip and place entire folder in a preferred location on your computer. `PIDtoolbox.exe` can be found in `PIDtoolbox\main\PIDtoolbox.exe`. IMPORTANT, the contents of the `main` folder must remain there, so I'd recommend creating a shortcut to `PIDtoolbox.exe` and placing it on your desktop. Also, PIDtoolbox v0.2 uses `blackbox_decode.exe` from <a href="https://github.com/betaflight/blackbox-tools" target="blank">Betaflight/Cleanflight Blackbox Tools</a>, which is packaged within this download and must remain in the main folder. Please place your `.bbl` or `.bfl` log files right in the `main` folder. A Mac version is in the pipeline!

PIDtoolbox has been confirmed to run on Windows7/8/10 64bit machines, but if you have issues installing Matlab runtime, or running PIDtoolbox, please give feedback here <a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">(issues)</a>,
or drop a post to the Betaflight BlackBox Log Review Facebook group <a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">(Betaflight BlackBox Log Review Facebook group)</a>.

# How to use

For a detailed guide on running and using PIDtoolbox, please visit the <a href="https://github.com/bw1129/PIDtoolbox/wiki/PIDtoolbox-user-guide" target="blank">PIDtoolbox Wiki page</a>.

For a quick user guide, follow the steps below:

**(i)** Older versions of PIDtoolbox (pre v0.2) used `.csv` files exported from <a href="https://www.github.com/betaflight/blackbox-log-viewer/releases" target="blank">Betaflight Blackbox-log-viewer</a>. <a href="https://github.com/bw1129/PIDtoolbox/releases/tag/v0.2" target="blank">PIDtoolbox v0.2</a> has done away with that step, and now reads `.bbl` or `.bfl` files directly by using `blackbox_decode.exe` from <a href="https://github.com/betaflight/blackbox-tools" target="blank">Betaflight/Cleanflight Blackbox Tools</a>. Just place your `.bbl` or `.bfl` files right in the `main` folder along with `PIDtoolbox.exe` and `blackbox_decode.exe`. As stated earlier, the contents of this folder MUST not be moved.    

- **(ii)** I recommend always logging at 2k (unless you're running 1k loop rate in which case log at 1k), because the spectrograms only go to 1k. It is not recommended to log higher than 4k.

- **(iii)** It is recommended that you set debug mode to `GYRO_SCALED` for PIDtoolbox. This is because the program expects the debug variables to contain the unfiltered gyro data, which is used to plot the filtered vs unfiltered gyro spectrograms, and compute gyro phase latency online. That said, PIDtoolbox v0.2 will recognize if you have debug mode set to `DSHOT_RPM_TELEMETRY`, and will plot RPM data along with motor signals in the log viewer % output section. Future versions will be aimed at reading which debug mode is selected, and plotting the appropriate data, but for now just be aware that the debug mode you choose will result in different data contained under the `gyro unfiltered` variable name. For a list of debug modes and the information they contain, see <a href="https://github.com/betaflight/betaflight/wiki/Debug-Modes" target="blank">Betaflight/Cleanflight Blackbox Tools</a>

If you have issues installing Matlab runtime, or running PIDtoolbox, please give feedback here
<a href="https://github.com/bw1129/PIDtoolbox/issues" target="blank">(issues)</a>,
or drop a post to the Betaflight BlackBox Log Review Facebook group <a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">(Betaflight BlackBox Log Review Facebook group)</a>.

 I hope you find PIDtoolbox useful, and I welcome feedback from the FPV community.

Cheers! -Brian
