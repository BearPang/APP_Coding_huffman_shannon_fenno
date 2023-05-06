function [code_original,len_average,H_x,efficiency_coding]=Fenno_coding(p_1)
%费诺编码，要求输入信源概率分布p_1,输出平均码长，信源熵，编码效率

%检查p是否符合标准
check_p(p_1)

%变量命名
[~,name]=p_symbol_sequence(p_1,1);

%概率排序
p_1_sort=sort(p_1,'descend');

%pp是一个元胞数组，里面的每一个元胞都是一个组
pp={p_1_sort};


%初始化元胞最长的p_1这长
max_len=length(p_1_sort);

%储存编码的地方
ccode=cell(1,1);


%开始编码，只要还有不是单独的分组，就没有编码完成，就继续编码
while max_len~=1
    %当元胞最大的长度不等于1，就是还有分组还没分完全时就执行
    len_cell=length(pp);
    %检测pp里由多少个元胞
    for i_p=1:len_cell
        %对每一个元胞进行检测和分组
        p=pp{i_p};
        len_p=length(p);
        if len_p ~=1
            %如果这个元胞里面列表的长度不为1，就需要进行分组

            %寻找分割点
            %找出两组相减差值最接近0的组极为分割点
            err=[];
            for i_sym=1:len_p
                err_i=abs(sum(p(1:i_sym))-sum(p(i_sym+1:end)));
                err=[err,err_i];
            end
            index_min=find(err==min(err),1);

            %在pp中更新p
            %p_code0是应该编码为0的组的概率，p_code1是应该编码为1的组的概率
            p_code0=p(1:index_min);
            p_code1=p(index_min+1:end);
            pp={pp{1:i_p-1},p_code0,p_code1,pp{i_p+1:end}};
            %原来pp中旧的一组概率被分割成两组，并更新


            %在ccode中更新code
            code_0=strcat(ccode{i_p},'0');
            code_1=strcat(ccode{i_p},'1');
            ccode={ccode{1:i_p-1},code_0,code_1,ccode{i_p+1:end}};
            %原来ccode中旧的一组编码替换为加上尾巴0或1后的两组新的编码

            %更新完这一组就跳出循环，开始下一轮更新，防止数据错位
            break
        end
    end

    %更新最长的值,如果最长的值不是1，说明还没有编码完成，就break出去。
    for i_p=1:length(pp)
        if length(pp{i_p})>1
            max_len=length(pp{i_p});
            break
        else
            max_len=1;
        end
    end

end

%输出编码的平均长度，信源熵，编码效率
[len_average,H_x,efficiency_coding]=coding_efficiency_indicators(p_1_sort,ccode,2);


%排序后的输出
output_rankled=[sprintfc('%g',p_1_sort(1,:));ccode];


%原始顺序输出%
p_copy=p_1_sort;
code_original=[];
for i=1:length(p_1)
    index=find(p_copy==p_1(i),1);
    code_original=[code_original,[output_rankled(:,index)]];
    output_rankled(:,index)=[];
    p_copy(:,index)=[];
end

code_original=[name;code_original];
code_original=[{'变量名';'概率';'编码'},code_original];

end
