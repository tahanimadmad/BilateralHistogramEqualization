
function [IndSlicesInputs] = generateIndicator(ROI, AM)
U = unique(AM);
[M,N] = size(AM);
IndSlicesInputs = zeros(M,N,length(U));
for ll = 1 : length(U)
    TempVar1 = zeros(size(ROI));
    TempVar1(AM==ll)= 1 ;
    IndSlicesInputs(:,:,ll) = TempVar1;
end

end
