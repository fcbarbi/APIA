function sobjtt4 = TT4( sobjtri )
% Cria uma nova serie com a variacao interanual de uma serie trimestral 
% Retorno taxa de variação internaual expressa em percentagem
% --------------------------------
% fcbarbi 25 out 2013
% --------------------------------

global SERIE MENSAL TRIMESTRAL ANUAL; 

sobjtt4 = sobjtri;

if sobjtri.freq ~= TRIMESTRAL
   error('TT$() deve ser chamada com uma serie trimestral'); 
end;    

sobjtt4.dados(1:4,1) = NaN;

for i=5:size(sobjtri.dados,1)
    sobjtt4.dados(i) = sobjtri.dados(i)./sobjtri.dados(i-4);
end;    

sobjtt4.dados = (sobjtt4.dados - 1)*100;


