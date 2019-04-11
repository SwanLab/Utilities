function [ f ] = constraints_ipopt( x,fobj )

global post_info

 if ~isequal(post_info.xold_constr,x)
     [post_info.constr,~,post_info.gradient_constr,~] = fobj(x);
     post_info.xold_constr = x;
 end
 f = post_info.constr;

end

