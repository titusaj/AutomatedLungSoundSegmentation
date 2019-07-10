
function [filter_out,downReGround ] = plotWaveCoeffResp(Signal,groundTruthEnvelope, Fs) 
   
    [c,l] = wavedec(Signal,10,'db2');
    approx = appcoef(c,l,'db2');
    [cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,sc10] = detcoef(c,l,[1 2 3 4 5 6 7 8 9 10]);
    
    
%     figure
%     subplot(4,1,1)
%     plot(Signal)
%     title('Signal')
%     subplot(4,1,2)
%     plot(cd3)
%     title('Level 3 Detail Coefficients')
%     subplot(4,1,3)
%     plot(cd2)
%     title('Level 2 Detail Coefficients')
%     subplot(4,1,4)
%     plot(cd1)
%     title('Level 1 Detail Coefficients')
% 
%     figure
%     subplot(4,1,1)
%     plot(Signal)
%     title('Signal')
%     subplot(4,1,2)
%     plot(cd6)
%     title('Level 6 Detail Coefficients')
%     subplot(4,1,3)
%     plot(cd5)
%     title('Level 5 Detail Coefficients')
%     subplot(4,1,4)
%     plot(cd4)
%     title('Level 4 Detail Coefficients')
% 
%     figure
%     subplot(4,1,1)
%     plot(sc10)
%     title('Level 10 Detail Coefficients')
%     subplot(4,1,2)
%     plot(cd9)
%     title('Level 9 Detail Coefficients')
%     subplot(4,1,3)
%     plot(cd8)
%     title('Level 8 Detail Coefficients')
%     subplot(4,1,4)
%     plot(cd7)
%     title('Level 7 Detail Coefficients')
%     
    


    %wn= [250 1000]*2 /4000; For wheeze
    %wn= [1 50]*2/4000; %For respiratory cycle 
    %n=2;
    %[b,a] = butter(n,wn,'bandpass');
    %filter_out= filtfilt(b,a,cd1);
    
    filter_out = lowpass(cd1,200,Fs);
    filter_out = filter_out/max(abs(filter_out));
    
     %reGround = resample(groundTruthEnvelope, 4000, Fs);
     downReGround = downsample(groundTruthEnvelope, 2);
%      
%       figure(1)
%       plot(downReGround,'r')
%       hold on
%       plot(filter_out )
%       ylim([-1 1])
%       hold off
end
    %

