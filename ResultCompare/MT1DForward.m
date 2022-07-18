function [apparentRho,Phase] = MT1DForward(rho,h,f)

   %计算频率个数nFreqs和地层层数nLayer
    nFreqs = length(f);
    nLayer = length(rho);
    apparentRho=zeros(21,1);
    Phase  = zeros(21,1);
    %对于每一个频率，都需要计算一次响应，因此大循环为频率
    for iFreq = 1:nFreqs
        omega = 2*pi*f(iFreq)  ;%ω为角频率(弧度)，ω=2πf
        u0 = 4*pi*1e-7    ;          %u0为真空磁导率(H/m)，u0=4π×10−7
        
        %小循环为每一层地层（从N层倒推第1层）
        for j = nLayer :-1:1
            k = sqrt(1i*omega*u0/rho(j));
            Z0 = sqrt(1i*omega*u0*rho(j));
            if j == nLayer  %计算到三层时
                Z = Z0;
                continue
            end
            R = (Z0-Z)/(Z0+Z);
            Q = exp(-2*k*h(j));
            Z  = Z0*(1-R*Q)/(1+R*Q);
        end     
        
        %最后计算每个频点的地表(第一层顶界面)阻抗，这里的Z即Zj=1
        Z(iFreq) = Z;
        
        %然后得到视电阻率和相位：
        apparentRho(iFreq) = (abs(Z(iFreq)).^2)./(omega*u0) ; %视电阻率
        Phase(iFreq) = atan2d(imag(Z(iFreq)),real(Z(iFreq))) ;     %相位
        % imag()表示复数的虚部，real()表示复数的实部
        %注意：公式里计算出的相位单位为弧度制，这里为°是因为使用atan2d函数转换成了度
      
    end
end 

