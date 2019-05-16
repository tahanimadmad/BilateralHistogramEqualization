function [J, TailleSlices] = SliceCutDR1(imgIn, NbrSlices)
    [m,n] = size(imgIn);
    maxx = max(imgIn(:));  minn = min(imgIn(:)); a= zeros(1,NbrSlices);
    b = a ;
    A = maxx-minn+1 ;
    Reste = mod(A,NbrSlices);
    Abis = A - Reste;
    TailleSlices = Abis/NbrSlices;
    a(1) = minn;
    b(1) = minn+TailleSlices - 1 ;
    for k = 2 : NbrSlices-1
        a(k) = b(k-1) + 1;
        b(k) = a(k) + TailleSlices - 1;
    end
        a(NbrSlices) = b(NbrSlices-1) + 1 ;
        b(NbrSlices) = maxx;
  J = zeros(m,n,NbrSlices);   
  NewMin = 0 ;
  NewMax = 2^8 - 1;
   for k = 1:NbrSlices
    T = imgIn ; T(T<a(k))=a(k);  T(T>b(k))=b(k);
    J(:,:,k) = round(((T- a(k)) .*((NewMax - NewMin) /(b(k)-a(k))) )) + NewMin ;
   end
end
