
function sobj_dados = ProjecaoContabil( mobj )
% --------------------------------------
% Projecao Contabil pressupõe: 
% 1.todos os pesos conhecidos 
% 2.todas as variáveis contemporaneas (em t)
% Caso falte variável contemporanea retorna []
% --------------------------------------
% exemplo de uso:
% mx3.tipo = MODELOCONTABIL;
% mx3.freq = ;
% mx3.modelo = [{'x1',0.8},{'x2',0.2}];
% x3p. = ProjecaoContabil( mx3 );
% disp( [x3p.dados x3.dados] );
% --------------------------------------
% fcbarbi set/out 2013 

erro = 0; 
global SERIE MODELOCONTABIL;

% DEBUG
% mobj.modelo = [{x1,0.8},{x2,0.4}];
% size(mobj) retorna [1 4]

if (mobj.tipo ~= MODELOCONTABIL)
   erro = -1;    
   error('ProjecaoContabil(): Argumento não é um modelo contabil...');
end;    

termos = size(mobj.modelo,2);

%verifica que o nbr de termos (pares regressor-peso) do modelo eh par
if (mod(termos,2)~=0)
   erro = -1;
   error('ProjecaoContabil(): O numero de termos deve ser par pois cada componente tem seu peso.');
end;   

termos = termos/2;

%verifica que todos os componentes tem a mesma freq
% frequencia = mobj.modelo{1,1}.freq;
% i = 2;
% while (i<termos && erro==0)
%   if (mobj.modelo{1,i*2-1}.freq ~= frequencia)   
%     erro = -1;  
%     error('ProjecaoContabil(): Componente(s) deve(m) a ter mesma frequencia.');  
%   end;
%   i = i+1;
% end;    

% verifica que todos os componentes tem os mesmos dados 
% pode ser preenchido ate m1, m2 ou m3 mas se um tem m3 todos devem ter m3
linhas = size(mobj.modelo{1,1}.dados,1);
i = 2;
while (i<termos && erro==0)
  if (size(mobj.modelo{1,i*2-1}.dados,1) ~= linhas)   
    erro = -1;  
    error('ProjecaoContabil(): Componente(s) deve(m) ter mesmo numero de observacoes.');  
  end;
  i = i+1;
end;    

if (~erro)    
    %sobj = NovaSerie( frequencia, [] );    
    % calcula previsao pela combinacao linear dos componentes e seus pesos
    X = []; betas = [];
    for i=1:termos    
        X = [ X mobj.modelo{1,i*2-1}.dados ];
        betas = [ betas mobj.modelo{1,i*2} ];
    end;    
    %verifica que pesos somam 100% senao...     
    if (sum(betas)~=1.0) 
      warning('ProjecaoContabil():Pesos nao somam 100%.');      
      % ...avisa e repondera OU...  
      % warning('ProjecaoContabil():Pesos reponderados.');
      % soma_betas = sum(betas);
      % betas = betas/soma_betas;      
      % ...encerra processamento com erro (Fabiano 11/10/13)  
      %error('ProjecaoContabil():Pesos não somam 100%.');
    end;

    sobj.dados = X*betas';
    sobj_dados = sobj.dados;
else 
    sobj_dados = [];
end;


    
    
