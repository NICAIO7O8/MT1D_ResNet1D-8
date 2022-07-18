clear;clc
k=1;
t=60;
T=logspace(0,4,t)';  %周期
figure
for i=1:5
    jixian=readmatrix('ResNet1d18andResNet1d8.xlsx','Sheet',i,'Range','a2:a61');
    apparentResistivity18=readmatrix('ResNet1d18andResNet1d8.xlsx','Sheet',i,'Range','b2:b61');
    apparentResistivity31=readmatrix('ResNet1d18andResNet1d8.xlsx','Sheet',i,'Range','c2:c61'); 
%         figure(2)
        subplot(2,3,k)
        k=k+1;
        plot(T,jixian,'k','LineWidth',1.5);
        hold on
        plot(T,apparentResistivity18,'-.g','LineWidth',1.5);
        plot(T,apparentResistivity31,'-.m','LineWidth',1.5);
%         plot(T,tuihuo,'-.y','LineWidth',1.5);
        set(gca, 'YScale', 'log');
        set(gca, 'XScale', 'log');
        axis equal
        axis([10^0 10^4 10^0 10^4]);
        set(gca,'XDir','Reverse'); %Y倒轴     
        set(gca,'LineWidth',1)
        xlabel('Frequency(Hz)');
        ylabel('apparentResistivity(Ωm)')
        hold off
end
legend('True Model','Predicted data (ResNet1D-18)','Predicted data (ResNet1D-8)')


