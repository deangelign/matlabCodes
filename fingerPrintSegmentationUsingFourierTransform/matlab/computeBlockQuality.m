function [blocksOverlap] = computeBlockQuality(blocksOverlap,blocksRow,blocksCol)
   
    base = 16;
    [overRow overCol]= size(blocksOverlap.data{1,1});
    
    u0 = blocksOverlap.u0;
    v0 = blocksOverlap.v0;
    frSum = 0;
    nElements = 0;
    
    
    for i=1:blocksRow
        for j=1:blocksCol
            
            blocksOverlap.F{i,j} = fftshift(fft2(blocksOverlap.data{i,j}));
            blocksOverlap.Ff{i,j} = blocksOverlap.F{i,j};
            blocksOverlap.F_m{i,j} = abs(blocksOverlap.F{i,j});
            
            F_m_noDC = blocksOverlap.F_m{i,j};
            F_m_noDC(v0,u0) = 0;
            
            
            
            maxValue = max(F_m_noDC(:));
            [vp up] = find(F_m_noDC == maxValue);
            up = up(1);
            vp = vp(1);
            
%             if (i == 6 && j == 6)
%                up 
%                vp
%             end
        
            u = (up-u0);
            v = (vp-v0);
%             if (i == 6 && j == 6)
%                 u
%                 v
%             end
%             blocksOverlap.fr{i,j} =  sqrt( (u^2) + (v^2));
            blocksOverlap.theta{i,j} = atan2((vp-v0),(up-u0));
      
            blocksOverlap.M = 2^((log(overRow)/log(2))-(log(base)/log(2)));
            F_m_noDC_noCircularRidge_5th = F_m_noDC;
            
            for row=1:size(F_m_noDC,1)
                for col=1:size(F_m_noDC,2)
                    v = (row-u0)^2;
                    u = (col-v0)^2;
                    d = sqrt(u+v);
                    if((d >= blocksOverlap.fr{i,j} && d <= blocksOverlap.fr{i,j}+blocksOverlap.M))
                        F_m_noDC_noCircularRidge_5th(row,col) = 0;
                    end
                    if(F_m_noDC_noCircularRidge_5th(row,col)/maxValue >= 0.05)
                        F_m_noDC_noCircularRidge_5th(row,col) = 0;
                    end        
                end
            end
            
            
            
            blocksOverlap.NP{i,j} = max(F_m_noDC_noCircularRidge_5th(:));
            [row col] = find(F_m_noDC == blocksOverlap.NP{i,j});
            blocksOverlap.RP{i,j} = max(F_m_noDC(:));
            
            if(F_m_noDC(up,vp) > 0)
                blocksOverlap.Q{i,j} = 1 - (blocksOverlap.NP{i,j}/F_m_noDC(vp,up));
            else
                blocksOverlap.Q{i,j} = 1 ;
            end
            
%             if(blocksOverlap.Q{i,j}> 0.75)
%                 frSum =  frSum + blocksOverlap.fr{i,j};
%                 nElements = nElements + 1;
%             end
%             
            blocksOverlap.variance{i,j} = var(double(blocksOverlap.data{i,j}(:)));
            if(blocksOverlap.variance{i,j} <= 1)
                blocksOverlap.Q{i,j} = -1;
                blocksOverlap.count{i,j} = -1;
                continue;
            end
            %np = blocksOverlap.NP{i,j};
            %fm = F_m_noDC(vp,up);
            %if(blocksOverlap.Q{i,j} < 0)
            %    disp('');
            %end
            
%              if(i == 6 && j==6)
% %                 figure()
% %                 imshow(mat2gray(log(blocksOverlap.F_m{i,j}+1)));
%                  figure()
%                  imshow(mat2gray(log(F_m_noDC+1)));
%                   hold on
%                   plot(up,vp,'r*');
%                   hold on
%                   plot(col(1),row(1),'b*');
% %                  figure()
% %                 imshow(mat2gray(log(F_m_noDC_noCircularRidge_5th+1)) );
%              end
           
        end
    end
    
%     blocksOverlap.Afr = frSum/nElements;
    
end