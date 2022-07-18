clear;clc
k=1;
load zaoshenjixian_new.mat
figure
for i =1:5

     rho_plot=zaoshenjixian_new{i}(:,1);
     thk_plot=zaoshenjixian_new{i}(:,2);
    XX0=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','d2:d63');
    YY=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','e2:e63');
    XX1=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','f2:f63'); 
    XX3=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','g2:g63'); 
    XX5=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','h2:h63'); 
    XX10=readmatrix('NoiseSummary.xlsx','Sheet',i,'Range','i2:i63'); 

    subplot(3,2,i)
    stairs(rho_plot,thk_plot,'b','Linewidth',1.5);
    hold on
    plot(XX0,YY,'-r','Linewidth',1.5)
    plot(XX1,YY,'--m','Linewidth',1.5)
    plot(XX3,YY,'--y','Linewidth',1.5)
    plot(XX5,YY,'--','Linewidth',1.5)
    plot(XX10,YY,'--k','Linewidth',1.5)

    axis([10^-1 10^4 0 2200]);
    set(gca,'YDir','Reverse'); %Y倒轴
    set(gca, 'XScale', 'log'); %X变对数
    xlabel('Resistivity(Ωm)')
    ylabel('Depth(m)')
       set(gca,'LineWidth',1)
    hold off
end
legend('True Model','Predicted Data(ResNet1D-8 gaussian noise 0%) ','Predicted Data(ResNet1D-8 gaussian noise 1%)','Predicted Data(ResNet1D-8 gaussian noise 3%)','Predicted Data(ResNet1D-8 gaussian noise 5%)','Predicted Data(ResNet1D-8 gaussian noise 10%)')
