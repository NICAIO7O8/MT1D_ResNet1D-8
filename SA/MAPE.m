    % Y是真值，Y_YC是预测值XX是这组数的均方根误差
    function XX = MAPE(Y,Y_YC)
    XX = mean(abs((Y - Y_YC)./Y))*100;
    end