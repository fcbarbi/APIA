
function multi = MultiplicaSeries( varargin ) 
% --------------------------------
% Multiplica dados de series de freq diferentes e retorna uma serie MENSAL 
% Cuidado: nao aceita se uma das series esta vazia mas 
% aceita se uma das series tiver menos dados que as demais
% --------------------------------
% fcbarbi out 2013
 
global ANUAL MENSAL TRIMESTRAL;

% lista as linhas que sem NaN
% find(~isnan(varargin{1}.dados))

 erro = 0;

 multi = NovaSerie( MENSAL, eye(size(varargin{1}.dados,1) ) );
  
 for i=2:nargin
   if (varargin{1}.freq ~= varargin{i}.freq)            
     warning('MultiplicaSeries(): Series de frequencias diferentes serao mensalizadas.');
   end;    
 end;    

 % mensaliza antes de multiplicar 
 for i=1:nargin
    if varargin{i}.freq~=MENSAL 
     smensal = MensalizaSerie( varargin{i} );
     varargin{i}.dados = smensal.dados;
     % disp(i), disp( size(varargin{i}.dados ));
    end;
 end;    

 if (~erro)    
   multi.dados = varargin{1}.dados(:,:);
   for i=2:nargin
    multi.dados = multi.dados .* varargin{i}.dados(:,:);     
   end; 
 else
   multi.dados = [];
 end;    
