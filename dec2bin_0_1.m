function code_bin=dec2bin_0_1(number_dec)
%0~1之间的数字，十进制转二进制,返回二进制小数部分的列表（大于一的数字可以用）
% ：先将小数乘以2得到的积的整数部分取出；
% 用小数乘以2得到的小数减去取出的整数部分得到新的小数，将用新的小数乘2得到的积的整数部分取出；
% 用新的小数乘以2得到的小数减去取出的整数部分又得到新的小数；
% 重复上述过程，直到积中的小数部分为零（也就是T=0）停止。把取出的整数部分按先后顺序排列起来得到二进制
%保证32位精度的情况下，其实不用判断T
 i=1;
 code_bin=fix(number_dec*2);
 T=number_dec*2-code_bin;
 a(i)=code_bin;
 while i<=32
     i=i+1;
     number_dec=T;
     code_bin=fix(number_dec*2);
     T=number_dec*2-code_bin;
     a(i)=code_bin;
 end
 code_bin=a(1:1:i);  

 %防止输入为0时位数不够报错
 if number_dec==0
     code_bin=zeros(1,33);
 end
 end
