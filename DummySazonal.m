function sobj = DummySazonal( mes )
% gera serie MENSAL com dummies para o mes 

global SERIE MENSAL config;

sobj.tipo = SERIE;
sobj.freq = MENSAL;

if (mes<1 || mes>12)
    error('SerieSazonal() chamada com mes invalido.');    
end;

sobj.ano0 = config.ano0;
sobj.mes0 = config.mes0;

M = AnoMes( config.ano, config.m3 );
dados = [];

for i=1:M
 dummy = 0;
  if mod(i,12) == mes
    dummy = 1;     
 end; 
 dados = [ dados; dummy ];     
end;

sobj.dados = dados;