function sobjL = DiffSerie( sobj, ordem_lag );
% Gera serie em diferenca de ordem L, por default L=1
% ---------------------------------------------------
% Exemplo de Uso:
% lepe_saD1 = DiffSerie( lepe_sa );
% ---------------------------------------------------

global TRIMESTRAL MENSAL config;

%sobj = lons_sa; ordem_lag = 1;

if (nargin<2)
    ordem_lag = 1;
end;

if (sobj.freq==TRIMESTRAL)
    T = AnoTrimestre(config.ano,config.trimestre);
end;

if (sobj.freq==MENSAL)
    T = AnoMes(config.ano,config.m3); 
end;

dados = diff( sobj.dados, ordem_lag );

sobjL = NovaSerie( sobj.freq, [ repmat([NaN],ordem_lag,1) ; dados(1:T-ordem_lag,1) ] );