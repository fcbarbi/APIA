function linha = AnoTrimestre( ano, tri, ano0, tri0 )
% --------------------------------------
% Numero de linhas entre duas datas, usando ano0,tri0 como data-base.
% Se os parameros ano0,tri0 nao forem passados, assume que as series 
% começam em config.ano0,config.tri0 (01/2003)
% --------------------------------------
% exemplo: AnoTrimestre( 2013,3,1991,1 ) = 273
% fcbarbi 22 out 2013 
% --------------------------------------

global config;

if (nargin<3)
 ano0 = config.ano0;
end;

if (nargin<4)
 tri0 = config.tri0;
end;

if (~isnumeric(ano) || ano<ano0 || tri>config.ano)
    error('AnoTrimestre() chamado com trimestre invalido...');
end;    

if (~isnumeric(tri) || tri<1 || tri>4 || tri0<1 || tri0>4)
    error('AnoTrimestre() chamado com trimestre invalido...');
end;    

if (ano==config.ano && tri>config.trimestre)
   error('AnoTrimestre() chamado com ano/trimestre invalido (futuro)...');  
end;

linha = (ano-ano0)*4+(tri-tri0)+1;

