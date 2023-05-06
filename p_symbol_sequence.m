function [p_sequence,name]=p_symbol_sequence(p_1,n)
%p_1是单个符号的概率分布,n是符号序列的符号个数，假设信源是无记忆信源
%（此处符号序列排布方式是从低位开始增加，eg:u1u1,u1u2,u2u1,u2u2）
%p_sequence是符号序列的概率密度，name返回的是各个符号的名字
% p_1=sort(p_1,'descend');
% 按照从大到小方式排布(但是为了保持原有的输入顺序，这里就不排序了)
len_p=length(p_1);
p_high=p_1;
name_original={};
for i=1:len_p
    name_original=[name_original,strcat('u',num2str(i))];
end


if n==1
    p_sequence=p_1;
    name=name_original;
end

%对于多重的编码，name是字符串组成的元组，p是数值型，是概率
%使用了三层for
name_high=name_original;
if n>=2
    for i=2:n
        len_p_high=length(p_high);
        p_tem=[];
        name_tem={};
        for sym_1=1:len_p
            for sym_2=1:len_p_high
                p_tem=[p_tem,p_1(sym_1)*p_high(sym_2)];
                name_tem=[name_tem,strcat(name_original(sym_1),name_high(sym_2))];
            end
        end
        p_high=p_tem;
        name_high=name_tem;
    end
    p_sequence=p_high;
    name=name_high;
end
end



