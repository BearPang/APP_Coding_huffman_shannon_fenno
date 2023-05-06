function  check_p(p)
%检查输入的概率p是否为正确的形式
if ~isempty(find(p<0, 1))
    error('概率不应该小于0！')
end

if abs(sum(p)-1)>10e-10
    error('概率之和不为1，请检查输入！')
    %注意这里不能用sum（p）~=1，因为会出现0.3+0.3+0.3+0.1~=1的情况
end
end
