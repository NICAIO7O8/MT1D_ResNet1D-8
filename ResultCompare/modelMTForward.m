function [apparentResistivity, phase] = modelMTForward(resistivities, thicknesses,frequency)

mu = 4*pi*1E-7; %磁导率(H / m) 
w = 2 * pi * frequency; %角频率(弧度);
n1=length(resistivities); %层数

impedances = zeros(n1,1);
%层分布按照这种格式
%  Layer     j
% Layer 1    1
% Layer 2    2
% Layer 3    3
% Layer 4    4
% Basement   5
%

% Steps for modelling (for each geoelectric model and frequency)

% 1. Compute basement impedance Zn using sqrt((w * mu * resistivity))
% 2. Iterate from bottom layer to top(not the basement)
    % 2.1. Calculate induction parameters
    % 2.2. Calculate Exponential factor from intrinsic impedance
    % 2.3 Calculate reflection coeficient using current layer
    %          intrinsic impedance and the below layer impedance
    
% 3. Compute apparent resistivity from top layer impedance
        %   apparent resistivity = (Zn^2)/(mu * w)

%建模步骤(针对每个地电模型和频率)  
% 1。 用根号((w * mu *电阻率))计算基底阻抗Zn  
% 2。 从底层迭代到顶层(而不是底层)  
  % 2.1。 计算电感参数  
  % 2.2。 从固有阻抗计算指数因子  
  % 2.3利用电流层计算反射系数  
%固有阻抗和下一层阻抗  
% 3。 从表层阻抗计算视电阻率  
%视电阻率= (Zn^2)/(mu * w)  



%Symbols
% Zn - Basement Impedance
% Zi - Layer Impedance
% wi - Intrinsic Impedance
% di - Induction parameter
% ei - Exponential Factor
% ri - Reflection coeficient
% re - Earth R.C.

%符号  
% Zn -基底阻抗  
% Zi -层阻抗  
% wi -本征阻抗  
% di -诱导参数  
% ei -指数因子  
% ri -反射系数  
% re - Earth R.C.    
% 步骤1:计算基底阻抗
Zn = sqrt(sqrt(-1)*w*mu*resistivities(n1)); 
impedances(n1) = Zn; 

%从层j=n-1(即在底层之上的层)开始迭代各个层         
for j = n1-1:-1:1
    resistivity = resistivities(j);
    thickness = thicknesses(j);
                
    % 3。 从表层阻抗计算视电阻率  
     %步骤2。 从底层迭代到顶层(而不是底层)  
        % Step 2.1计算电流层的固有阻抗  
    dj = sqrt(sqrt(-1)* (w * mu * (1/resistivity)));
    wj = dj * resistivity;
        
%     从固有阻抗计算指数因子  
    ej = exp(-2*thickness*dj);                     

    % Step 2.3利用电流层计算反射系数  
       %固有阻抗和下一层阻抗  
    belowImpedance = impedances(j + 1);
    rj = (wj - belowImpedance)/(wj + belowImpedance); 
    re = rj*ej; 
    Zj = wj * ((1 - re)/(1 + re));
    impedances(j) = Zj;               
end
%步骤3。 从表层阻抗计算视电阻率  
Z = impedances(1);
absZ = abs(Z); 
apparentResistivity = (absZ * absZ)/(mu * w);
phase = atan2d(imag(Z),real(Z));
    