function [ngaus] = gauss_points(type)

% C�lculo n�mero de puntos de Gauss seg�n tipo elemento

    switch type
        case {'LINEAR_TRIANGLE','LINEAR_TRIANGLE_MIX','LINEAR_TRIANGLE_MIX_COUPLED'}
            ngaus = 1;
        case 'QUAD'
            ngaus = 4;
        otherwise
            error('El elemento no est� implementado')
    end
    
end
        