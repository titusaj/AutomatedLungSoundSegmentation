function  windowEventSignalSplit(eventSignal,ogFs,hardware,EventOverallCount,patientNum)
   
        windowSplits = ogFs*1E-3;
        windowOverlap = .5;     
        
        [F,T] =v_enframe(eventSignal,1500,windowOverlap);
        length(F(:,1))
        for i=1:length(F(:,1))
%             
%             if ((windowStarts(i))+windowOverlap) < length(eventSignal)
%                 s = (windowStarts(i)+1);
%                 e = (windowStarts(i)+1)+windowOverlap;
%                 splitSignal = eventSignal(s:e);
%                 %length(splitSignal)
%             else
%                 s = (windowStarts(i)+1);
%  
%                 splitSignal = eventSignal(s:end);
%                 %length(splitSignal)
%             end
            
           
            [filter_out] = plotWaveCoeff(F(i,:),ogFs);
          
                if length(filter_out) > 128
                    spectrogram(filter_out,128,120,128,ogFs,'yaxis')
               
                    set(gca,'XTick',[]) % Remove the ticks in the x axis!
                    set(gca,'YTick',[]) % Remove the ticks in the y axis
                    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure

                    imageName = strcat('wheeze_',patientNum,'_',hardware,'_',num2str(i),'_',num2str(EventOverallCount+i));
                   
                    %Save figure
                    cd('CWTWheezeImages/')
                    saveas(gcf,imageName,'png') 
                    cd ..    
                end
        end
end