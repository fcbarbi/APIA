function sobjt = TruncaSerie( sobj, ano0, mes0 )
% --------------------------------------
% Trunca a serie para comecar no ano0,mes0
% Se a serie passada começar depois volta com vetor dados vazio
% serie2003 =  TruncaSerie( serie1991, 2003, 1 );
% --------------------------------------
% fcbarbi set/out 2013 
% --------------------------------------

global config;

if nargin<2
  ano0 = config.ano0;
end;

if nargin<3
  mes0 = config.mes0;
end;  

if (sobj.ano0*100+sobj.mes0 < ano0*100+mes0)
    sobjt = NovaSerie( sobj.freq, sobj.dados( ...
        AnoMes( ano0,mes0,sobj.ano0,sobj.mes0 ):end ), ano0, mes0 );
else 
    sobjt = NovaSerie( sobj.freq, [], ano0, mes0 );
end;    
   
    