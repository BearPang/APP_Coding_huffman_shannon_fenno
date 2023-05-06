function [code_original,len_average,Hx,efficiency_coding] = Shannon_coding(p_1)
%SHANNON_CODING 这是香农编码，输入要求输入信源概率分布p_1,输出平均码长，信源熵，编码效率
%   此处显示详细说明

%检查p是否符合标准
check_p(p_1)

%变量命名
[~,name]=p_symbol_sequence(p_1,1);

%概率排序
p_1_sort=sort(p_1,'descend');

%计算自信息量
I_x=-log2(p_1_sort);

%计算码长
len_code=ceil(I_x);

%计算累加概率
p_sum=0;
for i=1:length(p_1_sort)-1
    p_sum(i+1)=p_sum(i)+p_1_sort(i);
end

%储存编码的地方
ccode=cell(1,length(p_1_sort));

for i=1:length(p_1_sort)
    code_total=strrep(num2str(dec2bin_0_1(p_sum(i))),' ', '');
    code=code_total(1:len_code(i));
    ccode{i}=code;
end


%排序后的输出
output_rankled=[sprintfc('%g',p_1_sort(1,:));ccode];

%调整输出格式(显示为原始的输入顺序)
p_copy=p_1_sort(1,:);
%p_copy此时是调整后的顺序，即从大到小的顺序
code_original=[];
for i=1:length(p_1)
    index=find(p_copy==p_1(i),1);
    code_original=[code_original,[output_rankled(:,index)]];
    output_rankled(:,index)=[];
    p_copy(:,index)=[];
end

%让输出变得更直观
code_original=[name;code_original];
code_original=[{'变量名';'概率';'编码'},code_original];

%计算编码的效率（平均码长，信源熵，编码效率）
p_copy=p_1_sort(1,:);
code_ranked=ccode;
[len_average,Hx,efficiency_coding]=coding_efficiency_indicators(p_copy,code_ranked,2);

% fprintf('平均码长：%f\n',len_average)
% fprintf('信源熵：%f\n',Hx)
% fprintf('编码效率：%f\n',effi)

end
