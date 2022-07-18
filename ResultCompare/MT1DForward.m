function [apparentRho,Phase] = MT1DForward(rho,h,f)

   %����Ƶ�ʸ���nFreqs�͵ز����nLayer
    nFreqs = length(f);
    nLayer = length(rho);
    apparentRho=zeros(21,1);
    Phase  = zeros(21,1);
    %����ÿһ��Ƶ�ʣ�����Ҫ����һ����Ӧ����˴�ѭ��ΪƵ��
    for iFreq = 1:nFreqs
        omega = 2*pi*f(iFreq)  ;%��Ϊ��Ƶ��(����)����=2��f
        u0 = 4*pi*1e-7    ;          %u0Ϊ��մŵ���(H/m)��u0=4�С�10�6�17
        
        %Сѭ��Ϊÿһ��ز㣨��N�㵹�Ƶ�1�㣩
        for j = nLayer :-1:1
            k = sqrt(1i*omega*u0/rho(j));
            Z0 = sqrt(1i*omega*u0*rho(j));
            if j == nLayer  %���㵽����ʱ
                Z = Z0;
                continue
            end
            R = (Z0-Z)/(Z0+Z);
            Q = exp(-2*k*h(j));
            Z  = Z0*(1-R*Q)/(1+R*Q);
        end     
        
        %������ÿ��Ƶ��ĵر�(��һ�㶥����)�迹�������Z��Zj=1
        Z(iFreq) = Z;
        
        %Ȼ��õ��ӵ����ʺ���λ��
        apparentRho(iFreq) = (abs(Z(iFreq)).^2)./(omega*u0) ; %�ӵ�����
        Phase(iFreq) = atan2d(imag(Z(iFreq)),real(Z(iFreq))) ;     %��λ
        % imag()��ʾ�������鲿��real()��ʾ������ʵ��
        %ע�⣺��ʽ����������λ��λΪ�����ƣ�����Ϊ������Ϊʹ��atan2d����ת�����˶�
      
    end
end 

