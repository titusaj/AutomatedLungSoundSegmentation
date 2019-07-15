
function [downFilterOut,downReGround ] = plotWaveCoeffResp(Signal,groundTruthEnvelope, Fs) 



    wn= [250  1000]/4000; %For respiratory cycle 
    n=2;
    [b,a] = butter(n,wn,'bandpass');
    filter_out= filtfilt(b,a,Signal);
    
     norm_filter_out = filter_out - min(filter_out(:));
     norm_filter_out=  norm_filter_out./ max( norm_filter_out(:)); % *
%     
%     figure(1)
%     plot( norm_filter_out)
%     hold on 
%     plot(groundTruthEnvelope,'r')
%     hold off
%     
    
    %Get the hear 
    
%     [c,l] = wavedec(Signal,10,'db2');
%     approx = appcoef(c,l,'db2');
%     [cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,sc10] = detcoef(c,l,[1 2 3 4 5 6 7 8 9 10]);
%     
%     
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
%     
% 
% 
%    
%     wn= [1 50]*2/4000; %For respiratory cycle 
%     n=2;
%     [b,a] = butter(n,wn,'bandpass');
%     filter_out= filtfilt(b,a,cd1);
%     
%     filter_out = lowpass(cd1,1000,Fs);
%     length(filter_out)
%    filter_out = filter_out/max(abs(filter_out));
%     


     downFilterOut = downsample(norm_filter_out, 10);
     downReGround = downsample(groundTruthEnvelope, 10);
     
      figure(1)
      plot(downReGround ,'r')
      hold on
      plot(downFilterOut )
      %ylim([-1.5 1.5])
      hold off
 end
    


