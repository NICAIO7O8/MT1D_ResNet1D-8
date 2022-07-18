%输入一个位置矩阵，计算出对应的深度
%point为输入位置的点位矩阵，对应h就是每层的深度
%h为厚度矩阵
function [returnx]=deep(point,h)
    returnx(1,1)=sum(h(1,point(1,1):point(1,2)-1));
    returnx(1,2)=sum(h(1,point(1,2):point(1,3)-1));
    returnx(1,3)=sum(h(1,point(1,3):point(1,4)-1));
    returnx(1,4)=sum(h(1,point(1,4):point(1,5)-1));
    returnx(1,5)=sum(h(1,point(1,5):point(1,6)-1));
%     returnx(1,6)=sum(h(1,point(1,6):point(1,7)-1));

end