function sobj = NovaSerie( frequencia, dados, ano0, mes_tri_0, spec )
% Cria uma nova serie com frequencia e dados passados e 
% iniciando na data ano0,mes_tri_0 (opcionais). Na falta de ano0,mes_tri_0 
% usa os parametros config.ano0, config.mes0, config.tri0.
% --------------------------------
% fcbarbi 22 out 2013
% --------------------------------

global SERIE MENSAL TRIMESTRAL ANUAL; 
global config; 
global NO_SPEC SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;

sobj.tipo = SERIE;
sobj.freq = frequencia;

if (nargin<=2)
    ano0 = config.ano0;
end;    

if (nargin<=3)
    if (frequencia==MENSAL)
        mes_tri_0 = config.mes0;
    end;
    if (frequencia==TRIMESTRAL)    
        mes_tri_0 = config.tri0;
    end;     
end;

if (nargin<=4)
    if (frequencia==ANUAL)
      spec = NO_SPEC; 
    end; 
    if (frequencia==MENSAL)
      spec = SPEC_IBCBR; 
    end; 
    if (frequencia==TRIMESTRAL)    
      spec = SPEC_PIB; 
    end;   
end;
sobj.spec = spec;

sobj.ano0 = ano0;
if (frequencia==MENSAL)
    sobj.mes0 = mes_tri_0;
    sobj.tri0 = 0;
end;
if (frequencia==TRIMESTRAL)    
    sobj.mes0 = 0;
    sobj.tri0 = mes_tri_0;
end;
if (frequencia==ANUAL)    
    sobj.mes0 = 1;
    sobj.tri0 = 1;
end;

[dadosL dadosC] = size(dados);

% TODO
% if (frequencia==ANUAL)
%   if (ano0>size(dados,1))
% end;    
if (frequencia==MENSAL)
    final = AnoMes( config.ano, config.m3, ano0, mes_tri_0 );    
    if (dadosL<final)
        dados = [dados; repmat([NaN],final-dadosL,dadosC) ];
    end; 
end;    
if (frequencia==TRIMESTRAL)    
    final = AnoTrimestre( config.ano, config.trimestre, ano0, mes_tri_0 );
    if (dadosL<final)
        dados = [ dados; repmat([NaN],final-dadosL,dadosC) ];
    end;
end;

sobj.dados = dados;



