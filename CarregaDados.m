function dados = CarregaDados( nomearq,pasta,range,frequencia, ver_tam_max ) 
% --------------------------------
% Carregadados e conforma a dimensao dos dados ao periodo de estudo:
% 1.corta se ha mais dados
% 2.preenche com NaN os campos sem dados
% --------------------------------
% Exemplo de uso:
% mensais = CarregaDados( arqin,'mensais','C2:G130',MENSAL );
% trimestrais = CarregaDados( arqin,'trimestrais','C2:D43',TRIMESTRAL );
% --------------------------------
% Este procedimento eh essencial para garantir que os dados que nao estao
% disponiveis fiquem marcados com NaN para sinalizar p/as rotinas de 
% projecao que valores devem ser preenchidos.
% O comando xlsread() tem um "bug": se nao houver nenhum valor naa
% ultimas linhas ele simplesmente nao carrega estas linhas com NaN 
% e a matriz de dados fica com a dimensao menor do que a esperada 
% pelas rotinas de projecao.
% --------------------------------
% fcbarbi 22 out 2013
% --------------------------------

global MENSAL TRIMESTRAL config;

dados = xlsread( nomearq,pasta,range );
[dadosL dadosC] = size(dados);

% verifica tamanho maximo ?
% nao verifica se for apenas a serie final para ajuste sazonal
% cuidado que precisa ajustar manualmente o final da serie pois 
% a import do Excel "come" as ultima linhas se estiverem vazias
if (nargin<5)
    ver_tam_max = 1;
end;    

if (frequencia==MENSAL)
    final = AnoMes( config.ano,config.m3 );
    % corta se ha mais dados
     if (ver_tam_max && dadosL>final)
         dados = dados(1:final,:);
     end;    
    % preenche com NaN quando ha menos dados 
    if (dadosL<final)
        dados = [dados; repmat([NaN],final-dadosL,dadosC) ]
    end;    
end;

if (frequencia==TRIMESTRAL)
     %final = ceiling(M/3); % arredonda para cima 
     final = AnoTrimestre( config.ano,config.trimestre ); %% fcb ajustasaz...
     if (ver_tam_max && dadosL>final)
         dados = dados(1:final,:);
     end;   
    if (dadosL<final)
        dados = [ dados; repmat([NaN],final-dadosL,dadosC) ];
    end;    
end;

