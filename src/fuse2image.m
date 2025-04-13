% Function to create fused image from 2 input images
function fusedImage = fuse2image(Img1, Img2, ftype, wtype)

    % Wavelet decomposition (image -> wavelet coefficients matrixes): 
    %   1. Approximation coefficients (cA): Represents low-frequency components (image details with smooth transitions).
    %   2. Horizontal detail coefficients (cH): Captures the high-frequency variations along the horizontal direction (edges).
    %   3. Vertical detail coefficients (cV): Captures the high-frequency variations along the vertical direction (edges).
    %   4. Diagonal detail coefficients (cD): Captures high-frequency variations along the diagonal direction (edges).

    [cA1, cH1, cV1, cD1] = dwt2(double(Img1), wtype, 'per'); % Decomposition for image 1
    [cA2, cH2, cV2, cD2] = dwt2(double(Img2), wtype, 'per'); % Decomposition for image 2

    [row, col] = size(cA1);

    cA = zeros(row,col);
    cH = zeros(row,col);
    cV = zeros(row,col);
    cD = zeros(row,col);
   
    % Perform fusion of approximation (cA) and detail coefficients (cH, cV, cD) using specified fusion method (mean, max, min).
    switch ftype
        case 'MeanMean'
            cA = (cA1 + cA2) / 2;
            cH = (cH1 + cH2) / 2;
            cV = (cV1 + cV2) / 2;
            cD = (cD1 + cD2) / 2;
            
        case 'MeanMax'
            cA = (cA1 + cA2) / 2;
            cH = max(cH1, cH2);
            cV = max(cV1, cV2);
            cD = max(cD1, cD2);
            
        case 'MeanMin'
            cA = (cA1 + cA2) / 2;
            cH = min(cH1, cH2);
            cV = min(cV1, cV2);
            cD = min(cD1, cD2);
            
        case 'MaxMean'
            cA = max(cA1, cA2);
            cH = (cH1 + cH2) / 2;
            cV = (cV1 + cV2) / 2;
            cD = (cD1 + cD2) / 2;
            
        case 'MaxMax'
            cA = max(cA1, cA2);
            cH = max(cH1, cH2);
            cV = max(cV1, cV2);
            cD = max(cD1, cD2);
            
        case 'MaxMin'
            cA = max(cA1, cA2);
            cH = min(cH1, cH2);
            cV = min(cV1, cV2);
            cD = min(cD1, cD2);
            
        case 'MinMean'
            cA = min(cA1, cA2);
            cH = (cH1 + cH2) / 2;
            cV = (cV1 + cV2) / 2;
            cD = (cD1 + cD2) / 2;
            
        case 'MinMax'
            cA = min(cA1, cA2);
            cH = max(cH1, cH2);
            cV = max(cV1, cV2);
            cD = max(cD1, cD2);
            
        case 'MinMin'
            cA = min(cA1, cA2);
            cH = min(cH1, cH2);
            cV = min(cV1, cV2);
            cD = min(cD1, cD2);
    end


    % Perform the inverse 2D discrete wavelet transform (wavelet coefficients matrixes -> image)
    fusedImage = idwt2(cA, cH, cV, cD, wtype, 'per');
end
