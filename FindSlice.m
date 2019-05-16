function [SliceNumber] = FindSlice(PixelValue,NbrSlices, minn, maxx)
    DR = maxx-minn+1 ;
    Reste = mod(DR,NbrSlices);
    Abis = DR - Reste;
    TailleSlices = Abis/NbrSlices;
    Seuil = minn + (NbrSlices-1)*TailleSlices;
    SliceNumber=zeros(size(PixelValue));
    
    SliceNumber(PixelValue>Seuil)= NbrSlices;
    IND = find(~SliceNumber);
    P = PixelValue(:);
    
    si = (P - minn+1)/TailleSlices ;
    Frac = si - floor(si);
  
    SN = zeros(size(Frac));
    SN(Frac>0) = floor(si(Frac>0))+1;
    SN(Frac==0) = floor(si(Frac==0));
    SliceNumber(IND) = SN(IND);        
    
    end