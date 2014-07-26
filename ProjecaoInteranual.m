%function s1p_dados = ProjecaoInteranual( s1,s2 ) 
function s1p = ProjecaoInteranual( s1,s2 ) 
% --------------------------------
% exemplo de uso:
% Projeta valor de s1 segundo variacao interanual da serie s2.
% serie_projetada = ProjecaoInteranual( s_a_projetar, indicador ); 
% Cuidado: s_a_projetar e indicador devem ter a mesma freq
% --------------------------------
% fcbarbi out 2013

global config; 
global MENSAL TRIMESTRAL ANUAL;
erro = 0;
offset = 0;

%verifica se series com a mesma frequencia
if (s2.freq~=s1.freq)
   error('ProjecaoInteranual(): series devem ter a mesma frequencia');
end;  

if (s2.freq==ANUAL) offset = 1; end;
if (s2.freq==TRIMESTRAL) offset = 4; end;
if (s2.freq==MENSAL) offset = 12; end;

if (offset==0)    
  error('ProjecaoInteranual(): Frequencia nao reconhecida');
end;    

s1p = s1;
fator = 0;

% projeta apenas se nao houver dado efetivo (ie. preenchido com NaN)
if (s1p.freq==TRIMESTRAL) 
    %T1 = AnoTrimestre( config.ano, config.trimestre );
    if isnan(s1p.dados(end))   % (size(s1.dados,1)>=T1 && 
        fator = s2.dados(end)/s2.dados(end-offset);
        %disp('fator de projeção internaual (T) = '),disp(fator);
        s1p.dados(end) = s1p.dados(end-offset)*fator; 
    end;    
end;

if (s1p.freq==MENSAL) 
    %T1 = AnoMes( config.ano, config.m1 );
    if isnan(s1p.dados(end))
        fator = s2.dados(end)/s2.dados(end-offset);        
        %disp('fator de projeção interanual (M1) = '),disp(fator);        
        s1p.dados(end) = s1p.dados(end-offset)*fator;
    end;
    if isnan(s1p.dados(end+1))
        disp('fator de projeção interanual (M2) = '),disp(fator);
        %fator = s2.dados(T1+1)/s2.dados(T1+1-offset);
        s1p.dados(end+1) = s1p.dados(end+1-offset)*fator;
    end;
    if isnan(s1p.dados(end+2))
        fator = s2.dados(end+1)/s2.dados(end+2-offset);
        %disp('fator de projeção interanual (M3) = '),disp(fator);
        s1p.dados(end+2) = s1p.dados(end+2-offset)*fator;
    end;
end;

%s1p_dados = s1p.dados;

