function [constraint,constraint_gradient] = constraint_volume(design_variable,gamma_gp,dim,element,problembsc,coordinates,dvolu,Msmooth,P_operator,A_nodal_2_gauss,A_dvolu,algorithm,volume_integration)

switch volume_integration
    case 'natural_integration'
        switch algorithm
            case 'level_set'
                phi = design_variable;
                [~,~,~,~,volume,geometric_volume] = cal_vol_mat(phi,dim,element,problembsc,coordinates);
                
            case 'Projected_gradient'
                gamma = design_variable;
                geometric_volume = sum(Msmooth(:));
                volume = sum(Msmooth)*gamma;
                
        end
        
    case 'regularized_integration'
          geometric_volume = sum(Msmooth(:));
          volume = sum(A_dvolu*gamma_gp);
        
end
 



Vfrac = element.material.Vfrac;
constraint = volume/(geometric_volume*Vfrac) - 1;
%constraint_gradient = dvolu/(geometric_volume*Vfrac);
constraint_gradient = 1/(geometric_volume*Vfrac);
end