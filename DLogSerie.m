function sobjL = DLogSerie( sobj, ordem_lag );
% Gera serie em diferenca de ordem L, por default L=1
% ---------------------------------------------------
% Exemplo de Uso:
% lepe_saD1 = DLogSerie( lepe_sa );
% ---------------------------------------------------

global TRIMESTRAL MENSAL config;

if (nargin==1)
    ordem_lag = 1;
end;

if (sobj.freq==TRIMESTRAL)
    T = AnoTrimestre(config.ano,config.trimestre);
    inicio := sobj.tri0;
end;

if (sobj.freq==MENSAL)
    T = AnoMes(config.ano,config.m3); 
    inicio := sobj.mes0;
end;

if any(sobj.dados<=0)
 warning('DLogSerie() chamada com valor(es) zero ou negativo(s)');
end; 

sobjL_dados = diff( log( sobj.dados ), ordem_lag );

sobjL = NovaSerie( sobj.freq, [ repmat([NaN],ordem_lag,1) ; sobjL_dados(1:T-ordem_lag,1) ], sobj.ano0,inicio );