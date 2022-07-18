clc,clear,close all
mx=[2,6,10,40,80,120,160,180,200,220];
num=5000000;  %样本总个数
NUM=500000;   %检验样本个数
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
func= @(x) floor(x/t)+(mod(x,t)==0)*-1+1;
jz=mx(fix(unifrnd(1,length(mx)+1,[num,dw])));
TP=fix(unifrnd(1,dw,[num,C-dw]));
% % 
% for i=1:50
%     figure(i)
%     plot(jz(i,:));
% end

%%分布矫正 
v=3;
for i=1:num
    jz(i,1:v)=sort(jz(i,1:v),'ascend');
    if(jz(i,2)>jz(i,3)|| jz(i,3)<jz(i,4))
        jz(i,2:3)=sort(jz(i,2:3),'ascend');
        jz(i,3:4)=sort(jz(i,3:4),'descend');
        jz(i,4:5)=sort(jz(i,3:4),'descend');
    end
    jz(i,v+1:end)=sort(jz(i,v+1:end),'descend');

    if v==4
        v=3;
    else
        v=v+1;
    end
end


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
n=size(jz,1)
nn=n*t;
parfor i=1:nn
    [apparentResistivity(i),phase(i)] =modelMT(w(1+(ceil(i/t)-1)*C : C+(ceil(i/t)-1)*C),h,B(i));
end



% clear a v b B C DW func h num NUM phase t T TP dw gsjz jz mx

% save('w_500wan.mat','w')
% save('apparentResistivity_500wan.mat','apparentResistivity')

%-------------------------------------------------------------------------------------

load LY.mat %模型
% 设定样本数量
[m,n]=size(apparentResistivity);
num=n;  %样本总个数
NUM=100;   %检验样本个数
% 视电阻率数据归一标准化
app_log=log10(apparentResistivity); %取对数标准化
max_input=max(max(app_log));        %取最大值
app_a=app_log/max_input;            %映射到（0，1】
% 电阻率数据归一标准化 
w_log=log10(w);                     %取对数标准化
max_output=max(max(w_log));         %取最大值
w_a=w_log/max_output;               %映射到（0，1】
% 分配训练样本
app_a_train=app_a(:,1:num-NUM);     %抽出视电阻率训练数据
app_a_test=app_a(:,num-NUM+1:num);  %抽取电阻率测试数据
% 分配测试样本
w_a_train=w_a(:,1:num-NUM);         %抽出视电阻率训练数据
w_a_test=w_a(:,num-NUM+1:num);      %抽取电阻率测试数据
% 构建训练数据集
for i=1:num-NUM  
     XTrain{i,1}=app_a_train(:,i);
     YTrain{i,1}=w_a_train(:,i);
end
% 构建测试数据集
for i=1:NUM      
    XTest{i,1}=app_a_test(:,i);
    YTest{i,1}=w_a_test(:,i);
end

% 清空临时变量
clear app_a app_a_test app_a_train app_log ...
    w_a w_a_test w_a_train  w_log i

options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'MiniBatchSize',256, ...
    'InitialLearnRate',0.001, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',5,...
    'LearnRateDropFactor',0.6,...
    'Shuffle','every-epoch', ...
    'Plots','training-progress',...
    'ValidationData',{XTest,YTest},...
    'ValidationFrequency',10000, ...
    'Verbose',1);


[resnet1d8net_500w,resnet1d8info_500w] = trainNetwork(XTrain,YTrain,layers,options);

save model_500wan.mat resnet1d8net_500w resnet1d8info_500w




