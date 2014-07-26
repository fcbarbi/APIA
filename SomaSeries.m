
function soma = SomaSeries( varargin ) 
% --------------------------------
% soma dados de series de mesma frequencia
% Cuidado: nao aceita se uma das series esta vazia mas 
% aceita se uma das series tiver menos dados que as demais
% --------------------------------
% fcbarbi out 2013

% PENSATA:
% Depois de testar a frequencia ha duas opções:
% seguir mesmo que haja um erro e devolver []
% chamar error() que interrompe o processamento
% quando for um erro do script vamos interromper mas quado 
% for falta de um dado que ainda nao existe na base a rotina 
% deve voltar com [] para se testar e seguir com o script.
% 

 global SERIE; 
 erro = 0; 
 
 soma = NovaSerie( varargin{1}.freq, [] );
 soma.dados = zeros(size(varargin{1}.dados,1),1);  

 %disp( nargin );
 %disp( varargin{1}.dados );
 
 for i=2:nargin
   if (varargin{1}.freq ~= varargin{i}.freq)       
     erro = -1;
     error('SomaSeries(): Todas as series devem ter a mesma frequencia.');
   end;    
 end;    
      
 if (~erro) 
   %soma.dados = sum( varargin{1:nargin}.dados );     
   for i=1:nargin
    soma.dados = soma.dados + varargin{i}.dados; 
    % sum(varargin{i}.dados);  % nao funciona 
   end; 
 else
   soma.dados = [];
 end;    
