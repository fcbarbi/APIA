function sobj_dados = ProjecaoSarima( sobj )
% function sobj_dados = ProjecaoEstatistica( mobj, steps )
% Nesta versao suporte apenas para ARDLX
% Futuro: VAR e VEC
% --------------------------------------
% Exemplo de uso:
% M1 = AnoMes(config.ano,config.m1);
% x3p.dados( [M1; M1+1; M1+2] ) = ProjecaoSarima( x3p, 3 )';
% Testa x3p antes para ver que mes(es) precisa(m) ser previsto(s),ie nao
% sobrescreve valor que ja exista em M1, M1+1 ou M1+2.
% --------------------------------------
% (ANTIGO) exemplo de uso:
% modelo_x3_level.tipo = MODELOESTATISTICO;
% modelo_x3_level.obs = 'x3_t = x3_{t-1} + x1_t + x1_{t-1} + log(x2_{t-1})';
% modelo_x3_level.Y = {'x3p','' }
% modelo_x3_level.X = [ {'x1','',0},{'x2','log',1},{'x3','',0} ];
% x3p.dados = ProjecaoEstatistica( modelo_x3_level );
% --------------------------------------
% fcbarbi set/out 2013 

global MENSAL TRIMESTRAL config;
global SPEC_PIB SPEC_IBCBR;

%sobj = x3p;

% if (sobj.freq==MENSAL)
%  spec = SPEC_IBCBR;
% end;
% if (sobj.freq==TRIMESTRAL)
%  spec = SPEC_PIB;
% end;

sobj_dados = sobj.dados;
[ajustado previsto] = X12( sobj ); % X12( sobj, spec );
%disp('previsto='),disp(previsto);

if (sobj.freq==MENSAL)
    %M1 = AnoMes(config.ano,config.m1);
    tp=1;
    for t=1:3
        if isnan(sobj_dados(end-3+t))  % dados(M1+t-1))
            sobj_dados(end-3+t,1) = previsto(tp,1);
            tp = tp+1;
        end;
    end;
end;

if (sobj.freq==TRIMESTRAL)
    if isnan(sobj_dados(AnoTrimestre(config.ano,config.trimestre)))
        %sobj_dados( AnoTrimestre(config.ano,config.trimestre) ) = previsto(1,1);
        sobj_dados( end ) = previsto(1,1);
    end;    
end;

sobj.dados = sobj_dados;

