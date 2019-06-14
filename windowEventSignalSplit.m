function  windowEventSignalSplit(eventSignal,ogFs,hardware,wheezeEventOverallCount)
   
        windowSplits = 3;
        windowOverlap = ogFs/3;
        windowStarts = (0:(length(eventSignal)/windowSplits):length(eventSignal));
        
        for i=1:windowSplits
            
            if ((windowStarts(i))+windowOverlap) < length(eventSignal)
                s = (windowStarts(i)+1);
                e = (windowStarts(i)+1)+windowOverlap;
                splitSignal = eventSignal(s:e);
                %length(splitSignal)
            else
                s = (windowStarts(i)+1);
 
                splitSignal = eventSignal(s:end);
                %length(splitSignal)
            end
            
           
            [filter_out] = plotWaveCoeff(splitSignal,ogFs);
            %%%%%% Here signal Remsamples
            Fs = 4000;

                if length(filter_out) > 128
                    %spectrogram(filter_out,128,120,128,Fs,'yaxis')

%                     set(gca,'XTick',[]) % Remove the ticks in the x axis!
%                     set(gca,'YTick',[]) % Remove the ticks in the y axis
%                     set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
% 
%                     imageName = strcat('wheeze_',hardware,'_',num2str(i),'_',num2str(wheezeEventOverallCount));
%                    
%                     %Save figure
%                     cd('CWTWheezeImages/')
%                     saveas(gcf,imageName,'png') 
%                     cd ..    
                end
        end
end