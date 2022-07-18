clc,clear,close all
mx=[2,6,10,40,80,120,160,180,200,220];

num=1000;  %样本总个数
NUM=100;   %检验样本个数

dw=6;  %电阻率个数
t=60;  %频率个数
C=60;  %插值长度
gsjz=zeros(num,dw-1);  %插值坑位
T=logspace(0,4,t)';  %周期
h=20+10.^(0.0295*(0:t-2)); %60层
% h=20+10.^(0.057*(0:t-2));  %40原值  
w=zeros(num,C);  %电阻率样本
apparentResistivity=zeros(t,num);  %视电阻率
phase=zeros(t,num);  %相位
B = repmat(T,1,num);
func = @(x) floor(x/t)+(mod(x,t)==0)*-1+1;
jz=mx(fix(unifrnd(1,length(mx)+1,[num,dw])));
TP=fix(unifrnd(1,dw,[num,C-dw]));

parfor j=1:num
    n=tabulate(TP(j,:));
    if length(n(:,2))==dw-1
        gsjz(j,:)=n(:,2)';
    else
        gsjz(j,:)=[n(:,2)',0];
    end
end

for i=1:num
    a=jz(i,:);b=gsjz(i,:);
    w(i,1:b(1)+2)=linspace(a(1),a(2),b(1)+2);
    w(i,b(1)+2:sum(b(1,1:2))+3)=linspace(a(2),a(3),b(2)+2);
    w(i,sum(b(1,1:2))+3:sum(b(1,1:3))+4)=linspace(a(3),a(4),b(3)+2);
    w(i,sum(b(1,1:3))+4:sum(b(1,1:4))+5)=linspace(a(4),a(5),b(4)+2);
    w(i,sum(b(1,1:4))+5:sum(b(1,1:5))+6)=linspace(a(5),a(6),b(5)+2);
end

w=w';
for i=1:num*t
    [apparentResistivity(i),phase(i)] = modelMT(w(1+(ceil(i/t)-1)*C : C+(ceil(i/t)-1)*C),h,B(i));
end


subplot(2,1,1)
    plot(1./B(:,2), apparentResistivity(:,2),'o','MarkerSize',5,'MarkerFaceColor',[0,0.45,0.74]);
   set(gca,'Yscale','log','Xscale','log','LineWidth',1.5,'FontSize',12); 
   % 'Y/Xscale','log',指定y/x轴的刻度是“Linear”还是“Log”;
    xlabel('periods [s]');
    ylabel('apparent \rho [\Omega m]')
    title('Rho');
    %axis([10^-3,10^3,10^0,10^4]);
subplot(2,1,2)
    plot(1./B(:,2),phase(:,2),'o','MarkerSize',5,'MarkerFaceColor',[0,0.45,0.74]);
    set(gca,'Xscale','log','LineWidth',1.5,'FontSize',12)
    xlabel('periods [s]');
    ylabel('phase [\circ]');
    title('Phase');
    %axis([10^-3,10^3,-inf,inf]);
    


