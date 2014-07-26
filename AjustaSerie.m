function sajustado = AjustaSerie( sobj )  % , spec )
% --------------------------------------
% Chama X12 para ajuste sazonal da serie sobj. Note que o spec
% ja deve estar definido como atributo da serie em sobj.spec.
% --------------------------------------
% fcbarbi set/out 2013 
% --------------------------------------

global MENSAL TRIMESTRAL SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;

%sobj = epe; spec = SPEC_IBCBR; % debug 

if ~isnumeric(sobj.dados) || all(isnan(sobj.dados))
     error('AjusteSazonal(): Erro na serie passada');
 end;
 
% if (nargin==1)
%     if (sobj.freq==MENSAL)
%        spec = SPEC_IBCBR; 
%     end;
%     if (sobj.freq==TRIMESTRAL)
%        spec = SPEC_PIB; 
%     end;
% end;    

[sajustado temp] = X12( sobj );



