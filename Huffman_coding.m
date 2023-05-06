function [code_original,len_average,Hx,effi]=Huffman_coding(p_1,r,n )
%这个是霍夫曼编码的核心代码，分别调用了check_p，first_compress，compress_pp等三个函数
%函数返回原始排列顺序下的编码，并展示原始顺序和重新排序后编码。
%code_original是原始输入顺序下的编码（3xn的cell数组）
% len_average是平均码长,Hx是信源熵,effi是编码效率
%当n>=2时，默认信源是无记忆信源
[p,name]=p_symbol_sequence(p_1,n);
%n重序列符号的概率
[pp,cp_1]=compress_pp(p,r) ; %pp为对p排序后矩阵
c={};%c为最终编码存储的位置
[cp_times,~]=size(pp);
%cp_times表示压缩的次数，cp表示compress压缩
%p压缩了n-1次，
for ii=1:r
    c=[c;num2str(ii-1)];
end
%对多于3行的pp的编码方式（先有规律编码，再最后一步编码）
if cp_times >=3
    for i=2:cp_times-1
        %对于除了最后一步之外的编码
        k1=pp(cp_times-i+2,:);
        k1(k1==0)=[];
        %去除这一行的0值
        k2=pp(cp_times-i+1,:);
        k2(k2==0)=[];
        %去除上一行的0值

        Ln1=length(k1);
        %寻找下一行中那个元素是上一行两个元素相加得来的
        for hh=1:Ln1
            if k1(hh)==k2(hh)
                continue;
            else
                hh_diff=hh;
                %此时hh_diff表示的意思：矩阵pp中第n-i+2行第hh个数字是由n-i+1行中的数字相加而来
                break;
            end
        end

        % 编码模块
        %c代表这一层的编码code，cc代表下一行的编码,cc_short代表短的编码（由非合并而来的符号的编码）
        %
        if hh_diff==1
            cc=c(hh_diff+1:length(c));

            for j=1:r
                cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
                cc=[cc;  cc_long  ];
            end
        else  %当hh_diff不为1的时候
            cc=[c(1:hh_diff-1);c(hh_diff+1:length(c))];
            for j=1:r
                cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
                cc=[cc;  cc_long  ];
            end
        end
        c=cc;
    end

    %最后一步的编码，第一次压缩s个
    k1=k2;
    k2=pp(1,:);
    for hh=1:length(k1)
        if k1(hh)==k2(hh)
            continue;
        else
            hh_diff=hh;%此时hh表示的意思：矩阵pp中第n-i+2行第hh个数字是由n-i+1行中的数字相加而来
            break;
        end
    end
    if hh_diff==1
        cc=c(hh_diff+1:length(c));

        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    else  %当hh不为1的时候
        cc=c(1:hh_diff-1);
        cc=[cc;c(hh_diff+1:length(c))];
        if cp_1==1
            cp_1=cp_1+1;%当s=1时需要加1，因为s=1时并未真正压缩，之前已经处理过，因此这里对应要做出变化
        end
        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    end
    c=cc;
end

%对于只进行了一步的编码（n=2）
if cp_times==2
    k1=pp(2,:);
    k1(k1==0)=[];
    k2=pp(1,:);
    for hh=1:length(k1)
        if k1(hh)==k2(hh)
            continue;
        else
            hh_diff=hh;%此时hh表示的意思：矩阵pp中第n-i+2行第hh个数字是由n-i+1行中的数字相加而来
            break;
        end
    end
    if hh_diff==1
        cc=c(hh_diff+1:length(c));

        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    else  %当hh不为1的时候
        cc=c(1:hh_diff-1);
        cc=[cc;c(hh_diff+1:length(c))];
        if cp_1==1
            cp_1=cp_1+1;%当s=1时需要加1，因为s=1时并未真正压缩，之前已经处理过，因此这里对应要做出变化
        end
        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    end
    c=cc;
end

%如果一步编码就结束了，那么直接编码就可以了
if cp_times==1
    c=c(1:length(pp));
end

% 排序后输出(概率从大到小)
% disp('概率从大到小的排序,第一行表示概率，对应的第二行表示霍夫曼编码：')
output_rankled=[sprintfc('%g',pp(1,:));c'];
% disp(output_rankled)

%原始顺序输出%
pp_copy=pp(1,:);
code_original=[];
for i=1:length(p)
    index=find(pp_copy==p(i),1);
    code_original=[code_original,[output_rankled(:,index)]];
    output_rankled(:,index)=[];
    pp_copy(:,index)=[];
end
%这段主要在debug，忽略就好
% whos output_original
% whos name
% disp(name)
code_original=[name;code_original];
code_original=[{'变量名';'概率';'编码'},code_original];


%计算编码的效率（平均码长，信源熵，编码效率）
pp_copy=pp(1,:);
code_ranked=c';
[len_average,Hx,effi]=coding_efficiency_indicators(pp_copy,code_ranked,r);


end
