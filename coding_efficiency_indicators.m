function [len_average,H_x,efficiency_coding]=coding_efficiency_indicators(p,code,r)
%这是计算编码效率的函数，输入p是矩阵，是信源的符号的概率分布，code是编码,r是r进制
% p要求是1xn的矩阵，efficiency_coding要求是对应的编码的元胞数组.

%计算熵函数
H_x=-sum(p.*log2(p));

%计算平均码长
len_average=0;
len_code_cell=length(code);
for i=1:len_code_cell
    len_average=len_average + p(i)*length(char(code(i)));
end
%计算编码效率
efficiency_coding=H_x/(len_average*log2(r));
end

