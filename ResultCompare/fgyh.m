%反归一化函数
function [XX]=fgyh(Y,max_output)
% X=YTest{11}.*max_output;
X=Y.*max_output;
XX=10.^X;
end