function [ IndAvr ] = AvrageIndicator( Threshold, imgIn, IndSlices, Labels )

[M,N] = size(imgIn);
% ----- MASK GENERATION
MASKROI = zeros(size(imgIn));
for k = 2 : size(imgIn,1)-1
   for l = 2 : size(imgIn,2)-1
        
       if abs( imgIn(k,l) - imgIn(k-1,l) ) < Threshold 
           MASKROI(k,l) = 1 ; MASKROI(k-1,l) = 1;
       end
       if abs( imgIn(k,l) - imgIn(k+1,l) ) < Threshold 
           MASKROI(k,l) = 1 ; MASKROI(k+1,l) = 1;
       end
       if abs( imgIn(k,l) - imgIn(k,l+1) ) < Threshold
           MASKROI(k,l) = 1 ; MASKROI(k,l+1) = 1;
       end 
       if abs( imgIn(k,l) - imgIn(k,l-1) ) < Threshold 
           MASKROI(k,l) = 1 ; MASKROI(k,l-1) = 1;
       end
    end
end
so = strel('disk',2);
afterOpening = imopen(MASKROI,so);
o = 2;
dp = strel('disk',o);
afterClosing = imclose(afterOpening,dp);
[ConnDeg, Num] = bwlabel(afterClosing,4);
while(Num>1000)
    o = o +1;
    dp = strel('disk',o);
    afterClosing = imclose(afterOpening,dp);
    [ConnDeg, Num] = bwlabel(afterClosing,4);
end
%------ AVERAGING THE INDICATOR
[ConnDeg, Num] = bwlabel(afterClosing,4);
IndAvr = zeros(size(IndSlices));
for p = 1 : length(unique(Labels))
        IND1 = IndSlices(:,:,p);
        IND1 = IND1(:);
        Loc = find(IND1);
    for k = 1 : Num
        Lab = ConnDeg(:);
        Deg = find(Lab == k);
        OverL = intersect(Deg,Loc);
        if ~isempty(OverL)
        Mb = length(Deg) ;
        Nb =  length(OverL); 
        Alpha = Nb/Mb;
        IND1(OverL)=Alpha;
        IND1(Deg)= Alpha;
        end
    end
        IndAvr(:,:,p) = reshape(IND1,[M,N]);
end

end

