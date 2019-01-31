# PIDtoolbox

PIDtoolbox is a GUI-based Matlab tool for analyzing Betaflight blackbox log files.
![](images/PIDtoolboxGUIexample.png)

The motivation behind the development of this tool was to create a user-friendly, objective, method for comparing between flights. This came after a realization of the way we often troubleshoot an issue with flight performance (e.g., vibrations, mid-throttle oscillation, propwash oscillation, etc). A typical scenario goes something like "run test flight 'A', make subjective assessment of performance, tweek parameters, run test flight 'B', make subjective comparison between A and B, re-tweek", and so on. The problem with this approach from a scientific standpoint is that it lacks objectivity and reliability. Subjective bias becomes particularly problematic when the differences between A and B are subtle. PIDtoolbox was designed with this in mind.

I am not an engineer, and what I know about control theory has only come from my experience with miniquads over that past 3-4 years. So for engineer types out there, PIDtoolbox may seem like a slightly unconventional approach to PID analysis. That said, I am a Neuroscientist with about ~15ys experience and publishing on the neural basis of oculomotor control, which believe it or not has a close resemblance to the flight characteristics of miniquads. I also study neuronal oscillations, hence the focus on spectrograms. PIDtoolbox was partly inspired by Plasmatree PID-analyzer (https://github.com/Plasmatree/PID-Analyzer), and the goal was to extend some of that functionality in a GUI-based program.

Over the past year or so, there has been increasing emphasis on advanced gyro and dterm filtering, particularly in the +150Hz range, and this has led to amazing improvments in flight characteristics. During that time I have been analyzing many blackbox log files in Matlab and noticed a consistent difference between copters that fly well and copters that do not, specifically in the 30-100Hz spectrum, which can often be seen in |PID error| during steadly-state flight. Most commanded copter motion is below ~20Hz (even if you're a Mr. Steele on the sticks, at best you might push this to 25-30Hz!), but from my analyses, activity between 30-100Hz tends to correlate with the kind of vibes we SEE during flight and in HD vide (things like mid-throttle oscillation, propwash, video jello, etc.). Although these frequencies cannot be filtered out, the goal of PIDtoolbox is to use it as an objective comparative index between A/B testing to help decide whether the changes between A-B tests (in software settings, hardware, mechanical, or otherwise) were effective. 

That said, below is everything you need to begin using PIDtoolbox. I hope you find it useful, and I would really appreciate feedback from the FPV community.

Cheers! -Brian White

# Download

There are a couple of ways you can download PIDtoolbox. 

1) If you have Matlab, you may simply download the repository of mfiles, place them in a folder, and run PIDtoolbox.m from the Matlab command prompt. You will need Signal Processing Toolbox installed for this to work.

2) If you do not have Matlab, you can simply download the standalone Windows version here (Windows Download). The initial download is fairly large because it includes the Matlab runtime program (MATLAB® Compiler Runtime, MCR), which then allows you to run any standalone Matlab program. The actual PIDtoolbox.exe is only ~14Mb.

Steps:

(i) Download the standalone Windows version here: ![](releases/). Unzip and place entire folder in your preferred location on your computer. 

(ii) If you're running Windows 10, install 'MyAppInstaller_mcr.exe' under 'PIDtoolbox\for_redistribution\'. This will install Matlab runtime on your computer, which is required for running standalone Matlab .exe programs. The good news is this is a one time installation, after which you can run any Matlab standalone.

For other versions of Windows, you can download the appropriote Matlab runtime executable here:
<a href="https://www.mathworks.com/products/compiler/matlab-runtime.html" target="blank">(Matlab-runtime)</a>

(iii) Run 'PIDtoolbox.exe', found in folder: 
'PIDtoolbox\for_redistribution_files_only\PIDtoolbox.exe'
NOTE: PIDtoolbox.exe and other files must remain in this folder.

# How to use:

PIDtoolbox will import .bbl, .bfl, or .csv files, but there are a few things you need to know: 

(i) Optional: If you wish to use .bbl or .bfl files directly, you will need to have a copy of 'blackbox_decode.exe' in the same directory as your .bbl/.bfl files. 'blackbox_decode.exe' is part of Betaflight/cleanflight blackbox-tools, and can be downloaded here:
<a href="https://www.github.com/betaflight/blackbox-tools" target="blank">(Betaflight Blackbox-tools)</a>

(ii) Recommended: Use .csv files! BUT NOTE, you MUST convert your your .bbl or .bfl file to a .csv file using Betaflight Blackbox-log-viewer. Save as .csv from there please!
 
Betaflight Blackbox-log-viewer can be downloaded here:
<a href="https://www.github.com/betaflight/blackbox-log-viewer/releases" target="blank">(Betaflight Blackbox-log-viewer)</a>

If you have issues installing Matlab runtime, or running  PIDtoolbox, please drop a post to the Betaflight BlackBox Log Review Facebook group: <a href="https://www.facebook.com/groups/291745494678694/?ref=bookmarks" target="blank">(Betaflight BlackBox Log Review Facebook group)</a>

Now, let's get on with a few examples:

