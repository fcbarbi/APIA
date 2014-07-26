function smensal = MensalizaSerie( sobj )
% --------------------------------
% Aumenta a frequencia de uma serie ANUAL ou TRIMESTRAL para MENSAL.
% --------------------------------
% fcbarbi 22 out 2013
% --------------------------------

global ANUAL MENSAL TRIMESTRAL;
global config;

mes0 = 0;

if (sobj.freq==MENSAL)    
    error('MensalizaSerie() chamada com serie mensal');
end;    

if (sobj.freq == ANUAL)
   mes0 = 1;
end;

if (sobj.freq == TRIMESTRAL)    
   mes0 = (sobj.tri0-1)*3+1;
end;

if (mes0==0)
  error('mes0 nao definido');
end;  

smensal = NovaSerie( MENSAL, [], sobj.ano0, mes0 );

if (sobj.freq==ANUAL)    
    smensal.dados = repmat( sobj.dados(1,:),12,1 );
end;
if (sobj.freq==TRIMESTRAL)    
    smensal.dados = repmat( sobj.dados(1,:),3,1 );
end;
    
periodos = size(sobj.dados,1);

% repete todas as colunas de sobj em 12 linhas por ano 
if (sobj.freq==ANUAL)    
    for ano=2:periodos
       if ano==periodos
          smensal.dados = [ smensal.dados ; repmat( sobj.dados(ano,:),config.m3,1 ) ];
       else
          smensal.dados = [ smensal.dados ; repmat( sobj.dados(ano,:),12,1 ) ];
       end;    
    end;    
end;    

if (sobj.freq==TRIMESTRAL)    
    for tri=2:periodos
       smensal.dados = [ smensal.dados ; repmat( sobj.dados(tri,:),3,1 ) ];
    end;    
end;    


