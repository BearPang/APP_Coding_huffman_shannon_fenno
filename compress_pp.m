function [pp,cp_1]= compress_pp(p,r)
%对p(行向量)进行压缩排序后得到的矩阵pp
%pp的每一行代表一次压缩后得到的概率的结果
check_p(p);%对p进行检验；
n=length(p);
%n是输入符号个数
p=sort(p,'descend');
%降序排列

%对初始的p长度进行验证，如果小于等于r则直接输出排序后的pp=p,第一步没有压缩，cp_1=0
if n<=r
    pp=p;
    cp_1=0;
    return;
end

cp_1=first_compress(n,r);  %cp_1表示第一次编码时的压缩量
p_nextline_short=sort([p(1:n-cp_1),sum(p(n-cp_1+1:n))],'descend');
%第一次压缩后的顺序
%令cp_1不为1使得p矩阵不会出现两行相同的情况
p_nextline_long=[p_nextline_short,zeros(1,cp_1-1)];
%把p1补充为p一样的长度
p=[p;p_nextline_long];
%把新的一行拼进原有的矩阵的下一行
% end

n_nextline=length(p_nextline_short);
%nn是合并之后的符号的个数

%后续霍夫曼编码
while(n_nextline>(r))
    p_nextline_short=sort([p_nextline_short(1:n_nextline-r),sum(p_nextline_short(n_nextline-r+1:n_nextline))],'descend');
    n_nextline=length(p_nextline_short);
    p=[p;[p_nextline_short,zeros(1,n-n_nextline)]];
end
pp=p;

end