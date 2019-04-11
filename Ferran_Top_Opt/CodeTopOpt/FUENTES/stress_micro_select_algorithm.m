function [cost_comp,structural_values,element,micros_evol,d_u,vdisp,nbdata,post,res_u,cost_sigma_change] = ...
                stress_micro_select_algorithm(phifunct_n,element,fixnodes,problembsc,coordinates,fext,dim,Group,h_C_0,iter,file_gid,file_write,flag_by_groups,flag_postproces_micro,u_ant,vol_void) 
                                             
kiter = 1;
res_u = 1;
[phigp_n] = interpol(phifunct_n,element,dim,problembsc); 
u = zeros(dim.nndof,10);  
u(:,1) = u_ant;

Path = file_write;
post_micro = 'images';
            
fprintf('residue  \n')            
while res_u(kiter) > problembsc.TOL  
    
    [structural_values,d_u,vdisp,nbdata,post] = module_M(phifunct_n,element,fixnodes,problembsc,coordinates,fext,dim,vol_void);
                                                
    u(:,kiter+1) = d_u;
    
   % res_u(kiter+1) = norm(u(:,kiter+1) - u(:,kiter))/norm(u(:,kiter) + 1);
    res_u(kiter+1) = norm(u(:,kiter+1) - u(:,kiter))/norm(u(:,2) + 1);
    cost_sigma_change(kiter) = structural_values.costfunc/abs(h_C_0);
    
    if flag_by_groups
    [element,micros,Ener] = call_newmicros_by_group(structural_values.stres,Group,element,dim,coordinates,problembsc.problemtype);
    micro_2_post = micros;
    else
    [element,micros,Ener] = call_newmicros(structural_values.stres,element,dim,problembsc,coordinates);
    micro_2_post = micros(element.micro_2_post);
    end
       
    micros_evol(:,kiter) = micro_2_post;
    cost_micro_change(kiter) = Ener/abs(h_C_0);
    
    structural_values.fext = change_Fext_format(fext.pointload);
    
    if flag_postproces_micro
    postprocess_micro(Path,micro_2_post,kiter)
    print_variables2gid_and_screen(kiter+iter,cost_sigma_change(kiter),0,0,0,0,0,problembsc,d_u,file_gid,file_write,coordinates,element,...
        dim,phifunct_n,zeros(size(phifunct_n)),zeros(size(phifunct_n)),post,zeros(size(phifunct_n)),vdisp,nbdata,0,cost_sigma_change(kiter),0,structural_values,0,0);

    end
    
    fprintf('%3.5f \n',res_u(kiter+1))
    
    kiter = kiter+1;

end

if flag_postproces_micro
postprocess_micros(Path,micros_evol,post_micro,problembsc.flag_change_macro)
end

cost_comp(1:2:2*(kiter-1)) = [cost_sigma_change];
cost_comp(2:2:2*(kiter-1)) = [cost_micro_change];



end