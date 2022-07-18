clc,clear,close all
mx=[2,6,10,40,80,120,160,180,200,220];
num=500;  %样本总个数
dw=6;  %电阻率个数
t=60;  %频率个数
C=60;  %插值长度
gsjz=zeros(num,dw-1);  %插值坑位
T=logspace(0,4,t)';  %周期
h=20+10.^(0.0295*(0:t-2)); %60层
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
%     w(i,sum(b(1,1:5))+6:sum(b(1,1:6))+7)=linspace(a(6),a(7),b(6)+2);

end

w=w';

parfor i=1:num*t
    [apparentResistivity(i),phase(i)] = modelMTForward(w(1+(ceil(i/t)-1)*C : C+(ceil(i/t)-1)*C),h,B(i));
end

% clear a v b B C DW func h num NUM phase t T TP dw  jz mx



%% 模型预测
load resnet1d18net_500w.mat
% 视电阻率数据归一标准化
app_log=log10(apparentResistivity); %取对数标准化
max_input=max(max(app_log));        %取最大值
app_a=app_log/max_input;            %映射到（0，1】
% 电阻率数据归一标准化
w_log=log10(w);                     %取对数标准化
max_output=max(max(w_log));         %取最大值
w_a=w_log/max_output;               %映射到（0，1】
% 分配训练样本
NUM=500;
app_a_test=app_a(:,1:NUM);  %抽取电阻率测试数据
% 分配测试样本
w_a_test=w_a(:,1:NUM);      %抽取电阻率测试数据
% 构建测试数据集
XTest=cell(NUM,1);
YTest=cell(NUM,1);
YPred18=cell(NUM,1);
for i=1:NUM
    XTest{i,1}=app_a_test(:,i); %生成输入集
    YTest{i,1}=w_a_test(:,i);   %生成输出对比集
    YPred18{i,1} = predict(resnet1d18net_500w,XTest{i});  %18层网络预测
end



%% 先反演再正演视电阻率拟合曲线画图
t=60;  %频率个数
T=logspace(0,4,t)';  %周期
B = repmat(T,1,10);
h=20+10.^(0.0295*(0:t-2)); %60层
for i=1:1:20
    m=i;
    
    jixian=apparentResistivity(:,m);
    YC_DZ18=fgyh(YPred18{m},max_output);  %预测数据反归一化
    [apparentResistivity18,phase18] = MT1DForward(YC_DZ18,h',B);
    figure(i)
        plot(T,jixian,'k','LineWidth',1.5);
        hold on
        plot(T,apparentResistivity18,'-.b','LineWidth',1.5);
        set(gca, 'YScale', 'log');
        set(gca, 'XScale', 'log');
        axis equal
        axis([10^0 10^4 10^0 10^4]);
        set(gca,'XDir','Reverse'); %Y倒轴     
        set(gca,'LineWidth',1)
        xlabel('Frequency');
        ylabel('apparentResistivity(Ωm)')
        hold off
end
legend('True Model apparentResistivity','Predicted apparentResistivity (ResNet1D-18)')


%% 阶梯图
 for i =150:10:200
    m=i;
    YC_DZ18=fgyh(YPred18{m},max_output);  %预测数据反归一化
    MX_DZ=fgyh(YTest{m},max_output);  %模型数据反归一化
    t=60;  %60层
    h=20+10.^(0.0295*(0:t-2));  %每层层厚

    SD=deep_y(h,t);  %预测数据深度
    [R,point] = fh(m,gsjz,w);

    thk=deep(point,h);  %模型层厚
    rho_plot = [0 R];  %模型阶梯图数据
    thk_plot = [0 cumsum(thk) max(thk)*10000]; %模型阶梯图数据

    rmse_18=RMSE(YTest{m},YPred18{m});
    MAPE_18=MAPE(YTest{m},YPred18{m});
            figure(i)
            table3=[rho_plot',thk_plot'];
            stairs(rho_plot,thk_plot,'b','Linewidth',2.5);
            hold on
            XX18=fgyh(YPred18{m},max_output);
            FAN_Ytest=fgyh(YTest{m},max_output);
            XX18=[XX18(1);XX18;XX18(end)];

            YY=deep_y(h,t)+thk(1)/2;
            YY=[0;YY;2500];
            YYY{i}=YY;
            plot(XX18,YY,'--g','Linewidth',2.5)
            axis([10^-1 10^4 0 2200]);
            set(gca,'YDir','Re verse'); %Y倒轴
            set(gca, 'XScale', 'log'); %X变对数
            legend('True Model','ResNet1D-18')
            xlabel('Resistivity(Ωm)')
            ylabel('Depth(m)')
      
 end


