function config = Inicializa( ano0, mes0, ano_atual, tri_atual )
% --------------------------------------
% Inicializa config globais 
% fcbarbi set/out 2013 
% --------------------------------------

%inicio das series 
config.ano0 = ano0;
config.mes0 = mes0;  

config.tri0 = floor(mes0/3)+1;

% periodo de trabalho: 3T2013
config.ano = ano_atual;
config.trimestre = tri_atual;

% meses no trimestre 
config.m1 = (tri_atual-1)*3+1;
config.m2 = (tri_atual-1)*3+2;
config.m3 = (tri_atual-1)*3+3;


