% --------------------------------------
% pim_projecao.m
% Projecao da PIM 
% fcbarbi 18 out 2013 
% --------------------------------------
% 
% L:\Area Tecnica\Conjuntura\Projecoes e Parametros\Projecao da PIM\2013\2013-10
%

clc; close all; clear all;

DefineConstantes;

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
global MENSAL TRIMESTRAL;
global SPEC_PIB SPEC_IBCBR SPEC_PIM;
global NO_CHECK;

% ano e mes de inicio dos dados, ano e MES de projecao da PIM 
global config;
config = InicializaM( 2003,1,2013,9 ); % Projeta Set 2013

global dir0;
% dir0 = 'C:\Users\07244260865\Documents\lab\gdp\';
%dir0 = 'C:\Users\fcbarbi\Google Drive\SPE\lab\gdp\';
dir0 = 'L:\Area Tecnica\Conjuntura\Projecoes e Parametros\PIB Trimestral\2013\2013T3\projecao\';

disp( 'Carrega dados...' );
arqin = strcat( dir0, 'dados_pibind.xlsx');
arqout = strcat( dir0, 'projecoes_pim.xlsx');
mensais = CarregaDados( arqin,'mensais','B2:u131',MENSAL );

% importa a serie completa para ajuste sazonal 
dados_pim = CarregaDados( arqin,'PIM','B2:k274',MENSAL, NO_CHECK ); % nao verifica tamanho maximo
%ProdInd = NovaSerie( MENSAL, dados_pim(:,01), 1991,1 );  % prod ind 
%ProdInd_sa = NovaSerie( MENSAL, dados_pim(:,09), 1991,1 );  % prod ind 
ProdInd = NovaSerie( MENSAL, dados_pim(:,02), 1991,1 );  % ind transf
ProdInd_sa = NovaSerie( MENSAL, dados_pim(:,10), 1991,1 );  % ind transf
ProdInd.spec = SPEC_PIM;

% ProdInd = NovaSerie( MENSAL, mensais(:,14) );
% ProdInd.obs = 'Producao Industrial (PIM)';
% ProdInd = NovaSerie( MENSAL, mensais(:,3) );
ProdInd.obs = 'Producao Industria TRANSFORMACAO (PIM)';
dl_ProdInd = DLogSerie( ProdInd );

ABPO = NovaSerie( MENSAL, mensais(:,08) );
ABPO.obs = 'ABPO';
dl_ABPO = DLogSerie( ABPO );

Anfavea = NovaSerie( MENSAL, mensais(:,09) );
Anfavea.obs = 'Anfavea Leves ou Pesados ?';   %% ????
dl_Anfavea = DLogSerie( Anfavea,1 );

ABCR = NovaSerie( MENSAL, mensais(:,06) );
ABCR.obs = 'Transito de veiculos pesados';
dl_ABCR = DLogSerie( ABCR );

Export_bk = NovaSerie( MENSAL, mensais(:,10) );
Export_bk.obs = 'Quantum de Exportacao de bk';
dl_Export_bk = DLogSerie( Export_bk );

Import_bk = NovaSerie( MENSAL, mensais(:,11) );
Import_bk.obs = 'Quantum de Importacao de bk';
dl_Import_bk = DLogSerie( Import_bk );

ONS = NovaSerie( MENSAL, mensais(:,13) );  
ONS.obs = 'ONS';
dl_ONS = DLogSerie( ONS );

Fenabrave = NovaSerie( MENSAL, mensais(:,4) );
Fenabrave.obs = 'Fenabrave (Licenciamento)';
dl_Fenabrave = DLogSerie( Fenabrave );

Cimento = NovaSerie( MENSAL, mensais(:,12) );
Cimento.obs = 'Producao de Cimento';
dl_Cimento = DLogSerie( Cimento );

M1 = AnoMes(config.ano,config.m1); 
ctem = NovaSerie( MENSAL, ones(M1,1) ); % constante mensal dos modelos 
dsaz01 = DummySazonal( 01 );
dsaz02 = DummySazonal( 02 );
dsaz03 = DummySazonal( 03 );
dsaz04 = DummySazonal( 04 );
dsaz05 = DummySazonal( 05 );
dsaz06 = DummySazonal( 06 );
dsaz07 = DummySazonal( 07 );
dsaz08 = DummySazonal( 08 );
dsaz09 = DummySazonal( 09 );
dsaz10 = DummySazonal( 10 );
dsaz11 = DummySazonal( 11 );

if ~isnan(ProdInd.dados(end)) 
  error('Ha valor efetivo na serie do PIM, limpe antes de prosseguir.');
end;  

%% Projecao Contabil da PIM

                    
% modelo usado tradicionalmente
% pim_contabil01.tipo = MODELOCONTABIL;
% pim_contabil01.obs = 'Modelo Contabil para PIM (EQ02 Eviews)';
% pim_contabil01.modelo = [...
%                         {ctem,-0.072905},...
%                         {dl_ABPO,0.125083},...
%                         {dl_Anfavea,0.062277},...
%                         {dl_ABCR,0.410085},...
%                         {dl_ONS,0.182788},...
%                         {dl_Import_bk,0.076101},...
%                         {dl_Export_bk,-0.031517},...
%                         {dl_Fenabrave,0.024627},...
%                         {dl_Cimento,0.045011},...
%                         {dsaz01,0.065939},...
%                         {dsaz02,0.069038},...
%                         {dsaz03,0.091492},...
%                         {dsaz04,0.074741},...
%                         {dsaz05,0.102407},...
%                         {dsaz06,0.071037},...
%                         {dsaz07,0.083099},...
%                         {dsaz08,0.077350},...
%                         {dsaz09,0.062832},...
%                         {dsaz10,0.087305},...
%                         {dsaz11,0.062957},...                        
%                          ];
                     
pim_contabil02.tipo = MODELOCONTABIL;
pim_contabil02.obs = 'Modelo Contabil para PIM_tranformação (EQ02 Eviews)';
pim_contabil02.modelo = [...
                        {dl_ABPO,0.425465},...
                        {dl_Anfavea,0.085331},...
                        {dl_ABCR,0.270921},...
                        {dl_Import_bk,0.071147},...
                        {dl_Fenabrave,-0.042242},...
                        {dl_Cimento,0.172926},...
                         ];
                     
%ind_pim_dlog = NovaSerie( MENSAL, ProjecaoContabil( pim_contabil01 ));  

ind_pim_dlog = NovaSerie( MENSAL, ProjecaoContabil( pim_contabil02 )); 

if isnan(ind_pim_dlog.dados(end)) 
  error( strcat('Projecao contabil nao retornou valor para indicador.',...
   'Verifique se todas as series tem valor para o ano-mes de projeção.') );  
end;    

ProdInd.dados(end) = exp( ind_pim_dlog.dados(end) ) * ProdInd.dados(end-1);

ProdInd_sa_calc = AjustaSerie( ProdInd );   
%ProdInd_sa.dados(end) = exp( ind_pim_dlog.dados(end) ) * ProdInd_sa.dados(end-1);
ProdInd_sa.dados(end) = ProdInd_sa_calc.dados(end);

disp( '-------------------------------------------------------' );    
disp( sprintf('Indicador PIM t/t-12 %3.2f %%',...
    (ProdInd.dados(end)/ProdInd.dados(end-12)-1)*100 ));
disp( sprintf('Indicador PIM t/t-1 %3.2f %%',...
    (ProdInd_sa.dados(end)/ProdInd_sa.dados(end-1)-1)*100 ));
disp( '-------------------------------------------------------' );







                     
                     
