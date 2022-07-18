%给出用来对应厚度的矩阵
%h是厚度矩阵，这里给的是一个一行59列的矩阵，t给的是频点个数
function [deep]=deep_y(h,t)
deep(1,1)=0;
for i=1:length(h)
    if i==t
        break
    end
    deep(i+1,1)=deep(1,1)+sum(h(1,1:i));
end
end