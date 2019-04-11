function [nelem,nnode,neleq]=data_elem(elements,type)
% Esta funci�n entrega informaci�n acerca del numero de elementos en el
% problema, el n�mero de nodos por elemento y el n�mero de grados de
% libertad por elemento dependiendo de la formulaci�n.
switch type
    case 'TRIANGLE'
        nelem  = size(elements,1);           % Number of elements
        nnode  = size(elements,2);           % Number of nodes per element
        neleq  = nnode*2;                    % Number of DOF per element
    case 'LINEAR_TRIANGLE_MIX'
        nelem  = size(elements,1);           % Number of elements
        nnode  = size(elements,2);           % Number of nodes per element
        neleq  = nnode*3;                    % Number of DOF per element
    case 'LINEAR_TRIANGLE_MIX_COUPLED'
        nelem  = size(elements,1);           % Number of elements
        nnode  = size(elements,2);           % Number of nodes per element
        neleq  = nnode*3;                    % Number of DOF per element
    case {'QUAD'}
        nelem  = size(elements,1);           % Number of elements
        nnode  = size(elements,2);           % Number of nodes per element
        neleq  = nnode*2;                    % Number of DOF per element
    case 'HEXAHEDRA'
        nelem  = size(elements,1);           % Number of elements
        nnode  = size(elements,2);           % Number of nodes per element
        neleq  = nnode*3;                    % Number of DOF per element    
    otherwise
        error('Formulaci�n no ha sido implementada')
end