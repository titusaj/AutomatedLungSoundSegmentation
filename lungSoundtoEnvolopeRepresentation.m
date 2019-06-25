          % This is for reading the segmenetation events
                            audioLabelData =  textread(textFilename); %Read the text file into workspace
                
                            cycleStart = audioLabelData(:,1); 
                            cycleEnd = audioLabelData(:,2);
                            cracklePresent = audioLabelData(:,3);
                            wheezePresent = audioLabelData(:,4);
                            numCycles = length(cycleStart);



              check = isempty(allIndexStarts)
                    if check == 0
                        if sum(cracklePresent) ~= numCycles
                            if Fs == 44100
                                %                              [groundTruthEnvelope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs );
                                %                              [cd1_filter_out,downReGround] = plotWaveCoeff(rawWholeSignal, groundTruthEnvelope, Fs);
                                %
                                %                              cd1_filter_out = downsample((cd1_filter_out(2:end)),10);
                                %                              downReGround = downsample(downReGround,10);
                                %
                                %
                                %                     %            [hilbertEnv] = envelopeExtraction(filter_out, Fs);
                                %
                                %                     %            groundTruthEnvelope = downsample(groundTruthEnvelope,100);
                                %                     %            hilbertEnv = downsample(hilbertEnv ,100);
                                %
                                %         %                      figure(1)
                                %         %                      plot(groundTruthEnvelope,'r')
                                %                     %              hold on
                                %                     %              plot(hilbertEnv)
                                %
                                %                                     cd('rawVector/')
                                %                                     %csvwrite(strcat(temp{1},'_data.csv'),hilbertEnv)
                                %                                     mex_WriteMatrix(strcat(temp{1},'_data.csv'),cd1_filter_out, '%10.10f', ',', 'w+'); % 30 times faster!
                                %                                     cd ..
                                %
                                %                                     cd('labels/')
                                %                                     %writematrix(strcat(groundTruthEnvolope,temp{1},'_label.csv'),'Delimiter',' ')
                                %                                     %csvwrite(strcat(temp{1},'_label.csv'),groundTruthEnvolope, '%i', ' ', 'w+');  % 30 times faster!
                                %                                     dlmwrite((strcat(temp{1},'_label.csv')),downReGround,' ')
                                %                                     cd ..
                                %
                                %                                     figure(1)
                                %                                     plot(cd1_filter_out)
                                %                                     hold on
                                %                                     plot(downReGround,'r')
                                %                                     hold off
                                %
                                %                                     fileCount = fileCount+1
                            end
                        end