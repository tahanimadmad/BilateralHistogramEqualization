function [ BHE, BHEcl ] = BilateralHistogramEqualization( inputImg,NbrBins, gdt, sigmaSpatial, sigmaRange , ClipThreshold)
%outputs = BilateralHistogramEqualization( ( inputImg,NbrBins, gdt,...
% sigmaSpatial, sigmaRange , ClipThreshold)

[M,N] = size(inputImg); minn= min(inputImg(:));maxx= max(inputImg(:)); imgIn = inputImg ; 
Labels = FindSlice(inputImg,NbrBins, minn, maxx);
Slices = SliceCutDR1(inputImg,NbrBins);
Slices = Slices(:,:,unique(Labels));
IndSlices = generateIndicator(inputImg, Labels); % indicator generation
%% GRADIENT MANAGEMENT
if gdt == 1
Threshold = 30; IndAvr = AvrageIndicator( Threshold, imgIn, IndSlices, Labels );
else
gdt = 0 ; 
IndAvr = IndSlices ;
end
%% WEIGHTMAPS BILATERAL FILTERING
edge = inputImg/maxx;
fbIndSlices= zeros(size(IndSlices));  % filtred weightmaps
WSum = zeros(size(inputImg));
iter = 2;
for k = 1 : length(unique(Labels))
    data = IndAvr(:,:,k); 
    for p = 1:iter
    fbIndSlices(:,:,k) = fastbilateralFilter(data, edge, sigmaSpatial, sigmaRange);
    data =  fbIndSlices(:,:,k);
    end
    WSum = WSum + fbIndSlices(:,:,k);
end
%% BHE - FUSION
W = zeros(size(fbIndSlices));
for mm = 1 : length(unique(Labels))
W(:,:,mm) = fbIndSlices(:,:,mm)./WSum;
end
BHE = Fusion(W, Slices, inputImg);
%% BHE(cl) - FUSION
W_cl = zeros(size(W));
for x = 1 : M
    for y = 1 : N
        WeightMap = W(x,y,:);
        clipLabels = find(WeightMap< ClipThreshold );
        weightsum = sum(WeightMap(WeightMap>ClipThreshold)-ClipThreshold);
        Res = (weightsum)/length(clipLabels);
        WeightMap(WeightMap>ClipThreshold)=ClipThreshold;
        WeightMap(clipLabels) = WeightMap(clipLabels) + Res;
        W_cl(x,y,:) = WeightMap;
    end
end
BHEcl = Fusion(W_cl, Slices, inputImg);

end

