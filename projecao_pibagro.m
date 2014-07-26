% --------------------------------------
% pibagro_projecao.m
% Modelo para estimacao do PIB Agro trimestral 
% fcbarbi 22 out 2013 
% --------------------------------------

clc;clear all;

DefineConstantes;

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
global MENSAL TRIMESTRAL ANUAL;
global SPEC_PIB SPEC_IBCBR;
global NO_CHECK;

% ano e mes de inicio dos dados, ano e trimestre atual 
global config;
config = InicializaT( 2000,1,2013,3 );

global dir0;
% dir0 = 'C:\Users\07244260865\Documents\lab\gdp\';
%dir0 = 'C:\Users\fcbarbi\Google Drive\SPE\lab\gdp\';
dir0 = 'L:\Area Tecnica\Conjuntura\Projecoes e Parametros\PIB Trimestral\2013\2013T3\projecao\';
%dir0 = 'C:\Users\70785201149\Documents\MATLAB\';

disp( 'Carrega dados...' );
arqin = strcat( dir0, 'dados_agro_fcb.xlsx');
arqout = strcat( dir0, 'projecoes_pibagro.xlsx');

trimestrais = CarregaDados( arqin,'PIB','B2:B72',TRIMESTRAL, NO_CHECK );
pibagro = NovaSerie( TRIMESTRAL, trimestrais(:,01), 1996,1 );

fatores_mensais = CarregaDados( arqin,'fatores_mensais',...
                            'B51:AJ215',MENSAL );
variacao_agro = CarregaDados( arqin,'variacao_agro','B13:AJ26',ANUAL );

% variacao de peso no abate do ano anterior (2000 a 2013)
variacao_pecu = CarregaDados( arqin,'variacao_pecuaria',...
                            'B40:F204',MENSAL );  
% variacao de peso no abate do ano anterior (1999 a 2012) p/a encadeamento
variacao_pecu_ant = CarregaDados( arqin,'variacao_pecuaria',...
                            'B28:F195',MENSAL, NO_CHECK );  

% como peso usamos o do ano anterior (de 1999 a 2012)
pesos = CarregaDados( arqin,'pesos','B3:AS16',ANUAL );

pesos_agro = NovaSerie( ANUAL, pesos(:,01:35)/100 );
pesos_pecu = NovaSerie( ANUAL, pesos(:,37:41)/100 );

% pesos no indice
pesos_agricultura = NovaSerie( ANUAL, pesos(:,43)/100 );
pesos_pecuaria    = NovaSerie( ANUAL, pesos(:,44)/1000 );  

% Agrega todas as 35 culturas para formar o indicador de agricultura
varia_agro = NovaSerie( ANUAL, 1+variacao_agro/100 );
fator_mensal = NovaSerie( MENSAL, fatores_mensais*12/100 );
agricultura = MultiplicaSeries( varia_agro, fator_mensal, pesos_agro );

%xlswrite( arqout, [agricultura.dados],'agricultura'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agricultura.dados = sum(agricultura.dados,2)*100;

%xlswrite( arqout, [agricultura.dados],'agricultura_sum'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Agrega as 5 categorias de pecuaria: bovinos,suinos,aves,leite,ovos
varia_pecu = NovaSerie( MENSAL, variacao_pecu );
varia_pecu_ant = NovaSerie( MENSAL, variacao_pecu_ant );
categorias = size(varia_pecu.dados,2);
% Media do Peso do abate (toneladas) do ano anterior 
Media = [];
M = 1; 
for ano=config.ano0-1:config.ano-1   
    Media(M:M+11,1:categorias) = ...
      repmat( mean( varia_pecu_ant.dados(M:M+11,1:categorias), 1), 12, 1)
    M=M+12;
end;
InvMedia = NovaSerie( MENSAL, 1./Media(:,:) );
M3 = AnoMes(config.ano,config.m3);
InvMediaAnoAnterior = NovaSerie( MENSAL,...
                                    InvMedia.dados(1:M3,1:categorias));

%xlswrite( arqout, [Media],'Media pecuaria ant'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%MediaAnoAnterior = NovaSerie( MENSAL, ...
%    repmat( InvMedia2.dados,1,size(varia_pecu.dados,2) ) );
pvaria_pecu = MultiplicaSeries( varia_pecu,InvMediaAnoAnterior  );
pvaria_pecu.dados = pvaria_pecu.dados * 100;

%xlswrite( arqout, [pvaria_pecu.dados],'pvaria_pecu'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pecuaria = MultiplicaSeries( pvaria_pecu, pesos_pecu );
pecuaria.dados = sum(pecuaria.dados,2)*100;

%xlswrite( arqout, [pecuaria.dados],'pecuaria'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pondera para chegar ao indice 
p_agricultura = MultiplicaSeries( pesos_agricultura, agricultura );
p_pecuaria    = MultiplicaSeries( pesos_pecuaria, pecuaria );
indicador_agro = SomaSeries( p_agricultura, p_pecuaria  );

%xlswrite( arqout, [indicador_agro.dados],'indicador_agro'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = AnoTrimestre(config.ano,config.trimestre);
indicador_agro_tri = TrimestralizaSerie( indicador_agro );

pibagrop = ProjecaoInteranual( pibagro, indicador_agro_tri );

pibagro_sa =  AjustaSerie( pibagrop );

disp( sprintf('pib AGRO t/t-4 %3.2f %',...
    (pibagrop.dados(end)/pibagrop.dados(end-4)-1)*100 ));
disp( sprintf('pib AGRO t/t-1 %3.2f %',...
    (pibagro_sa.dados(end)/pibagro_sa.dados(end-1)-1)*100 ));
disp( '-------------------------------------------------------' );


%xlswrite( arqout, [pecuaria.dados agropecuaria.dados],'proj_mes');  % mes_ano.dados  
%xlswrite( arqout, [trim_ano.dados indagro.dados pibagro.dados pibagrop.dados],'proj_tri');

% size(varia_agro.dados)
% size(pesos_agro.dados)
% size(fator_mensal.dados)
% 
% va = MensalizaSerie(varia_agro)
% pq = MensalizaSerie(pesos_agro)
