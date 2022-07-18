% Y是真值，Y_YC是预测值XX是这组数的均方根误差
function XX = RMSE(Y,Y_YC)
XX = sqrt(mean((Y-Y_YC).^2));
end
