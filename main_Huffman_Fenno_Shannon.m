%主程序
clc;
clear;
%霍夫曼测试
%第一组测试
% p=[0.16 0.14 0.13 0.12 0.10 0.09 0.08 0.07 0.06 0.04,0.01];
% r=2;%r代表r元码
%第二组测试
p_1=[0.01,0.22,0.18,0.16,0.08,0.04,0.01,0.30];
% p=[0.6,0.4];
% r=2;
% n=2;
% [code_original_huffman,len_average_huffman,Hx_huff,effi_huffman]=Huffman_coding(p,r,n);

% %费诺测试
% p_1=[0.2,0.19,0.18,0.17,0.15,0.1,0.01];
% [code_original_Fenno,len_average_Fenno,H_x_Fenno,efficiency_coding_Fenno]=Fenno_coding(p_1);
% 
% % %香农测试
% p_1=[0.1,0.2,0.3,0.4];
[code_original_Shannon,len_average_Shannon,Hx,efficiency_coding_Shannon] = Shannon_coding(p_1);

