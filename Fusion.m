
function [FResult] = Fusion(ind, J, ROI)

FResult = zeros(size(ROI));
for ff =1 : size(ind,3)
FResult = FResult + (J(:,:,ff).*ind(:,:,ff));
end

end

