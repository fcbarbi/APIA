function sobj = DummyMM( ano_ini, mes_ini, ano_fim, mes_fim )

% gera serie com zeros e a dummy=1 dentro do periodo definido entre
% (ano_ini, mes_ini) e (ano_fim, mes_fim)

global SERIE MENSAL config;

sobj.tipo = SERIE;
sobj.freq = MENSAL;

if (nargin<3)
    ano_fim = ano_ini;
end;    

if (nargin<4)
    mes_fim = mes_ini;
end;    

T = AnoMes( config.ano, config.m3 );
ini = AnoMes( ano_ini, mes_ini );
fim = AnoMes( ano_fim, mes_fim );

dados = [];

for i=1:T
    dummy = 0;
    if (i>=ini && i<=fim)
     dummy = 1;   
    end;
    dados = [ dados ; dummy ];
end;     

sobj.dados = dados; 
