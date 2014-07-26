function config = InicializaM( ano0, mes0, ano_atual, mes_atual )
% --------------------------------------
% Inicializa configuracoes globais para series MENSAIS (PIM, PMC)
% Ver InicializaT() para series Trimestrais (PIB)
% --------------------------------------
% fcbarbi set/out 2013 

%inicio das series 
config.ano0 = ano0;
config.mes0 = mes0;  
config.tri0 = floor(mes0/3)+1;

% periodo de trabalho, por ex: 2013M08
config.ano = ano_atual;
config.m1 = mes_atual;
config.m2 = mes_atual;
config.m3 = mes_atual;



