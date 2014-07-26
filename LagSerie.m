function sobjL = LagSerie( sobj, ordem_lag );
% Gera serie com lag de ordem L, por default L=1
% ---------------------------------------------------
% Exemplo de Uso:
% lepe_saL1 = LagSerie( lepe_sa );
% equivale para series mensais a fazer
% lepe_saL1 = NovaSerie( MENSAL, [ NaN; lepe_sa.dados(1:M3-1,1) ] );
% ---------------------------------------------------

global TRIMESTRAL MENSAL config;

if (nargin==1)
    ordem_lag = 1;
end;

if (sobj.freq==TRIMESTRAL)
    T = AnoTrimestre(config.ano,config.trimestre);
end;

if (sobj.freq==MENSAL)
    T = AnoMes(config.ano,config.m3); 
end;

sobjL = NovaSerie( sobj.freq,[ repmat([NaN],ordem_lag,1) ; sobj.dados(1:T-ordem_lag,1) ] );