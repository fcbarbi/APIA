function config = InicializaT( ano0, mes0, ano_atual, tri_atual )
% --------------------------------------
% Inicializa configuracoes globais, por ex: 
% ano0 = 2003 (ano/mes em que TODAS as series começam no banco de dados)
% mes0 = 1 
% ano_atual = 2013
% tri_atual = 3 se desejamos projetar 3T2013
% Se alguma serie so existe depois de jan/2003 TEM que fazer backcasting
% --------------------------------------
% fcbarbi set/out 2013 

%inicio das series 
config.ano0 = ano0;
config.mes0 = mes0;  

config.tri0 = floor(mes0/3)+1;

% periodo de trabalho: qdo desejamos projetar?
config.ano = ano_atual;
config.trimestre = tri_atual;

% meses no trimestre 
config.m1 = (tri_atual-1)*3+1;
config.m2 = (tri_atual-1)*3+2;
config.m3 = (tri_atual-1)*3+3;


