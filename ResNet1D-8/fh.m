%输入60个电阻率值，返回电阻率值a和位置b
%location表示第几个样本，gsjz表示位置的一个值，w用来返回电阻率
function [a,b] = fh(location,gsjz,w)
a(1,1)=w(1,location);    
b(1,1)=1;
a(1,2)=w(gsjz(location,1)+2,location);
b(1,2)=gsjz(location,1)+2;
a(1,3)=w(sum(gsjz(location,1:2))+3,location);
b(1,3)=sum(gsjz(location,1:2))+3;
a(1,4)=w(sum(gsjz(location,1:3))+4,location);
b(1,4)=sum(gsjz(location,1:3))+4;
a(1,5)=w(sum(gsjz(location,1:4))+5,location);
b(1,5)=sum(gsjz(location,1:4))+5;
a(1,6)=w(sum(gsjz(location,1:5))+6,location);
b(1,6)=sum(gsjz(location,1:5))+6;
% a(1,7)=w(sum(gsjz(location,1:6))+7,location);
% b(1,7)=sum(gsjz(location,1:6))+7;
end
