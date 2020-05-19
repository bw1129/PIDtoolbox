%%
precalcSmooth=50;

SampleDelay_A=[];SampleDelaytmp_A=[];%zeros(1,length(DATmainA.debug(1,:)));
PhaseDelay_A=zeros(1,length(DATmainA.debug(1,:)));
maxlag=A_lograte * 5;% 20ms  A_lograte * 6

wind=A_lograte*10000; %2sec
stpsz=A_lograte*1000;%ms steps 
j=1;
 hw = waitbar(0,'Please wait...'); 
for i=wind:stpsz:size(DATmainA.debug(1,:),2)-wind+1
    waitbar(i/length(DATmainA.debug(1,:)),hw);
    j=j+1;
     SampleDelaytmp_A(1,j)=finddelay(smooth(DATmainA.debug(1,i-wind+1:i+wind),precalcSmooth),smooth(DATmainA.GyroFilt(1,i-wind+1:i+wind),precalcSmooth),maxlag);  
     if SampleDelaytmp_A(1,j)<=0,
         if finddelay(smooth(DATmainA.debug(2,i-wind+1:i+wind),precalcSmooth),smooth(DATmainA.GyroFilt(2,i-wind+1:i+wind),precalcSmooth),maxlag) > 0
            % try pitch
            SampleDelaytmp_A(1,j)=finddelay(smooth(DATmainA.debug(2,i-wind+1:i+wind),precalcSmooth),smooth(DATmainA.GyroFilt(2,i-wind+1:i+wind),precalcSmooth),maxlag);
         end
     end
     if SampleDelaytmp_A(1,j)<=0,
         if finddelay(smooth(DATmainA.debug(3,i-wind+1:i+wind),precalcSmooth),smooth(DATmainA.GyroFilt(3,i-wind+1:i+wind),precalcSmooth),maxlag) > 0
             % try yaw
             SampleDelaytmp_A(1,j)=finddelay(smooth(DATmainA.debug(3,i-wind+1:i+wind),precalcSmooth),smooth(DATmainA.GyroFilt(3,i-wind+1:i+wind),precalcSmooth),maxlag);
         end
     end
     if SampleDelaytmp_A(1,j)<0,
         SampleDelaytmp_A(1,j)=0;
     end
         
end
close(hw)
SampleDelay_A=interp(SampleDelaytmp_A, floor(length(tta) / length(SampleDelaytmp_A(1,:))) );
PhaseDelay_A=SampleDelay_A * (sampTime / 1000);

supersmooth=20000;
figure;
subplot(211)
h=plot(tta,DATmainA.RCRate(4,:)/100);
set(h,'color',[.3 .3 .3])
hold on
% h=plot(tta,smooth(DATmainA.RCRate(4,:)/100, supersmooth));
% set(h,'color',[.3 .3 .3])
% hold on
h=plot(tta(1:length(PhaseDelay_A)),smooth(PhaseDelay_A,20),'-')
set(h,'color',[1 .2 .2],'linewidth',.5)
h=plot([tta(1) tta(length(PhaseDelay_A))],[nanmedian(PhaseDelay_A) nanmedian(PhaseDelay_A)])
set(h,'color',[1 .2 .2],'linewidth',2)
set(gca,'fontsize',20,'ygrid','on')
xlabel('')
ylabel('Phase lag (ms) | proportion throttle')
title('A')
axis([0 tta(end) 0 2.5])

nanmean(PhaseDelay_A(PhaseDelay_A>0))

% figure;plot(tta,DATmainA.GyroFilt(1,:))
% hold on
% plot(tta,DATmainA.debug(1,:))
% plot(tta(1:length(PhaseDelay_A)),smooth(PhaseDelay_A,10)*1000)


SampleDelay_B=[];SampleDelaytmp_B=[];%zeros(1,length(DATmainB.debug(1,:)));
PhaseDelay_B=zeros(1,length(DATmainB.debug(1,:)));
maxlag=B_lograte * 5;

wind=B_lograte*10000; %2sec
stpsz=B_lograte*1000;%1 ms steps
j=1;
hw = waitbar(0,'Please wait...'); 
for i=wind:stpsz:size(DATmainB.debug(1,:),2)-wind+1
     waitbar(i/length(DATmainB.debug(1,:)),hw);
    j=j+1;
     SampleDelaytmp_B(1,j)=finddelay(smooth(DATmainB.debug(1,i-wind+1:i+wind),precalcSmooth),smooth(DATmainB.GyroFilt(1,i-wind+1:i+wind),precalcSmooth),maxlag);  
     if SampleDelaytmp_B(1,j)<=0,% try pitch
         if finddelay(smooth(DATmainB.debug(2,i-wind+1:i+wind),precalcSmooth),smooth(DATmainB.GyroFilt(2,i-wind+1:i+wind),precalcSmooth),maxlag) >0
            SampleDelaytmp_B(1,j)=finddelay(smooth(DATmainB.debug(2,i-wind+1:i+wind),precalcSmooth),smooth(DATmainB.GyroFilt(2,i-wind+1:i+wind),precalcSmooth),maxlag);
         end
     end
     if SampleDelaytmp_B(1,j)<=0,% try yaw
         if finddelay(smooth(DATmainB.debug(3,i-wind+1:i+wind),precalcSmooth),smooth(DATmainB.GyroFilt(3,i-wind+1:i+wind),precalcSmooth),maxlag) > 0
            SampleDelaytmp_B(1,j)=finddelay(smooth(DATmainB.debug(3,i-wind+1:i+wind),precalcSmooth),smooth(DATmainB.GyroFilt(3,i-wind+1:i+wind),precalcSmooth),maxlag);
         end
     end 
     if SampleDelaytmp_B(1,j)<0,
         SampleDelaytmp_B(1,j)=0;
     end
end
close(hw)
SampleDelay_B=interp(SampleDelaytmp_B, floor(length(ttb) / length(SampleDelaytmp_B(1,:))) );
PhaseDelay_B=SampleDelay_B * (sampTime / 1000);


subplot(212)
h=plot(ttb,DATmainB.RCRate(4,:)/100);
set(h,'color',[.3 .3 .3])
% h=plot(ttb,smooth(DATmainB.RCRate(4,:)/100,supersmooth));
% set(h,'color',[.3 .3 .3])
hold on
h=plot(ttb(1:length(PhaseDelay_B)),smooth(PhaseDelay_B,20),'-')
set(h,'color',[.2 .4 1],'linewidth',.5)
h=plot([ttb(1) ttb(length(PhaseDelay_B))],[nanmedian(PhaseDelay_B) nanmedian(PhaseDelay_B)])
set(h,'color',[.2 .4 1],'linewidth',2)
set(gca,'fontsize',20,'ygrid','on')
xlabel('Time (ms)')
ylabel('Phase lag (ms) | proportion throttle')
title('B')
axis([0 ttb(end) 0 2.5])

nanmean(PhaseDelay_B(PhaseDelay_B>0))

% figure;plot(ttb,DATmainB.GyroFilt(1,:))
% hold on
% plot(ttb,DATmainB.debug(1,:))
% plot(ttb(1:length(PhaseDelay_B)),smooth(PhaseDelay_B,10)*1000)