function linha = AnoMes( ano, mes, ano0, mes0 )
% --------------------------------------
% Numero de linhas entre duas datas, usando ano0,mes0 como data-base.
% Se os parameros ano0, mes0 nao forem passados, assum que as series 
% começam em config.ano0,config.mes0 (jan/2003)
% --------------------------------------
% exemplo: AnoMes( 2013,9,1991,1 ) = 273
% fcbarbi 21 out 2013 
% --------------------------------------
global config;

%disp( config.ano );

if (nargin<3)
 ano0 = config.ano0;
end;

if (nargin<4)
 mes0 = config.mes0;
end;

if ~isnumeric(ano) || ~isnumeric(ano0) 
    error('AnoMes() chamado com ano invalido...');
end;    

if ~isnumeric(mes) || ~isnumeric(mes0) || mes<1 || mes>12 || mes0<1 || mes0>12
    error('AnoMes() chamado com mes invalido...');
end;    

if (ano==config.ano && mes>config.m3)
   error('AnoMes() chamado com ano/mes invalido...');  
end;

linha = (ano-ano0)*12+(mes-mes0)+1;

