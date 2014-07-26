% --------------------------------------
% projecao_pibsvc.m
% Projecao do PIB de serviços (trimestral)
% fcbarbi 25 out 2013 
% --------------------------------------

clc; close all; clear all;

DefineConstantes;

DEBUG = 0;

GravaIndicador = 0;
Calcula_PIBSVCIF = 1;  % intermediacao financeira
Calcula_PIBSVCTR = 0;  % transportes 
Calcula_PIBSVCCO = 0;  % comercio 

%Calcula_PIBSVCOU = 0;  % outros 
Calcula_PIBSVC = Calcula_PIBSVCCO & Calcula_PIBSVCTR & Calcula_PIBSVCIF; % & Calcula_PIBSVCOU;

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
global MENSAL TRIMESTRAL;
global SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;
global NO_CHECK;

global config;
% ano e mes de inicio dos dados e ano, trimestre atual atual 
config = InicializaT(2000,1,2013,3); % 1996 PIB, 2004 EPE

global dir0;
%dir0 = 'C:\Users\07244260865\Documents\lab\gdp\';
%dir0 = 'C:\Users\fcbarbi\Google Drive\SPE\lab\gdp\';
dir0 = 'L:\Area Tecnica\Conjuntura\Projecoes e Parametros\PIB Trimestral\2013\2013T3\projecao\';
%dir0 = 'C:\Users\70785201149\Documents\MATLAB\';

disp( 'Carrega dados...' );
arqin = strcat( dir0, 'dados_pibsvc.xlsx');
arqout = strcat( dir0, 'projecoes_pibsvc.xlsx');

trimestrais = CarregaDados( arqin,'PIB','B2:I72',TRIMESTRAL, NO_CHECK );

pibsvc     = NovaSerie( TRIMESTRAL, trimestrais(:,01), 1996,1 );
pibsvcco   = NovaSerie( TRIMESTRAL, trimestrais(:,02), 1996,1 );
pibsvctr   = NovaSerie( TRIMESTRAL, trimestrais(:,03), 1996,1 );
pibsvcinfo = NovaSerie( TRIMESTRAL, trimestrais(:,04), 1996,1 );
pibsvcif   = NovaSerie( TRIMESTRAL, trimestrais(:,05), 1996,1 );
pibsvcou   = NovaSerie( TRIMESTRAL, trimestrais(:,06), 1996,1 );
pibsvcalug = NovaSerie( TRIMESTRAL, trimestrais(:,07), 1996,1 );
pibsvcapu  = NovaSerie( TRIMESTRAL, trimestrais(:,08), 1996,1 );

% mensais = CarregaDados( arqin,'margem_comercio','B2:N130',MENSAL );
% margem = NovaSerie( MENSAL, mensais(:,1) );
% margem.obs = 'Margem de comércio';	
% 
% consumo = NovaSerie( MENSAL, mensais(:,1) );
% consumo.obs = 'Consumo famílias';	
% 
% governo= NovaSerie( MENSAL, mensais(:,1) );
% governo.obs = 'Gastos Governo';	
% 
% exporta= NovaSerie( MENSAL, mensais(:,1) );
% exporta.obs = 'Quatum de Exportação de BK';
% 
% mensais = CarregaDados( arqin,'transporte_passageiros','B2:N130',MENSAL );
% RPK_dom = NovaSerie( MENSAL, mensais(:,1) );	
% RPK_dom.obs = 'Revenue per Passsenger per Kilometer (RPK) Transp Aereo Domestico';	
% 
% RPK_int	= NovaSerie( MENSAL, mensais(:,1) );
% RPK_int.obs = 'Revenue per Passsenger per Kilometer (RPK) Transp Aereo Internacional';	
% 
% leves = NovaSerie( MENSAL, mensais(:,1) );
% leves.obs = 'ABCR trafego de veiculos leves';
% 
% mensais = CarregaDados( arqin,'transp_carga','B2:N130',MENSAL );
% pesados = NovaSerie( MENSAL, mensais(:,1) );
% pesados.obs = 'ABCR trafego de veiculos pesados';

mensais = CarregaDados( arqin,'financeiro','B2:C166',MENSAL );
emprestimos = NovaSerie( MENSAL, mensais(:,1) );
emprestimos.obs = 'CONTA COSIF 16000001';

depositos = NovaSerie( MENSAL, mensais(:,2) );
depositos.obs = 'CONTA COSIF 41000007';

trimestrais = CarregaDados( arqin,'financeiro','K2:K56',TRIMESTRAL );
deflator = NovaSerie( TRIMESTRAL, trimestrais(:,1) );

% controle de tempo, converte de relativo em posicao absoluta
T1 = AnoTrimestre(config.ano,config.trimestre);
M1 = AnoMes(config.ano,config.m1); M2 = M1+1; M3 = M2+1;
ctem = NovaSerie( MENSAL, ones(M3,1) ); % constante mensal dos modelos 

d_2003_01 = DummyM( 2003,01 );
d_2008_12 = DummyM( 2008,12 );

disp( '-------------------------------------------------------' );

%% Intermediacao Financeira 

if Calcula_PIBSVCIF

    if isnan(emprestimos.dados(M1))
        emprestimos.dados(M1) = emprestimos.dados(M1-1)*1.006;
    end;    
    if isnan(emprestimos.dados(M2))
        emprestimos.dados(M2) = emprestimos.dados(M1)*1.005;
    end;
    if isnan(emprestimos.dados(M3))
        emprestimos.dados(M3) = emprestimos.dados(M2)*1.005;
    end;    

    emprestimos_tri = TrimestralizaSerie( emprestimos );
    r_emprestimos_tri = DeflacionaSerie( emprestimos_tri, deflator );

    if DEBUG xlswrite( arqout, [emprestimos_tri.dados r_emprestimos_tri.dados],'r_emprestimos_tri'); end;
    
    if isnan(depositos.dados(M1))
        depositos.dados(M1) = depositos.dados(M1-1)*1.006;
    end;
    if isnan(depositos.dados(M2))
        depositos.dados(M2) = depositos.dados(M1)*1.006;
    end;
    if isnan(depositos.dados(M3))
        depositos.dados(M3) = depositos.dados(M2)*1.006;
    end;    

    depositos_tri = TrimestralizaSerie( depositos );
    r_depositos_tri = DeflacionaSerie( depositos_tri, deflator );

    if DEBUG xlswrite( arqout, [depositos_tri.dados r_depositos_tri.dados],'r_depositos_tri'); end;
        
    sifim_tri = SomaSeries( r_emprestimos_tri, r_depositos_tri );
    sifim_tri.obs = 'Servicos de Interediacao Financeira Indiretamente Medidos';
    
    if DEBUG xlswrite( arqout, [sifim_tri.dados],'sifim_tri'); end;
        
    sifim_tt4 = TT4(sifim_tri);
    
    % grava a serie mensal do indicador agro
    if GravaIndicador
        tempo = EntreDatas( TRIMESTRAL, sifim.ano0,...
                    sifim.tri0,config.ano,config.trimestre );
        xlswrite( arqout, [tempo sifim.dados],'sifim'); 
    end;
    
    pibsvcif_tt4 = TT4( pibsvcif );
    pibsvcif_L1_tt4 = LagSerie( pibsvcif_tt4,1 );

    if_contabil.tipo = MODELOCONTABIL;
    if_contabil.obs = 'Modelo Contabil com pessos de SMART2_C2 (Eviews)';
    if_contabil.modelo = [   {pibsvcif_L1_tt4, 0.429349},...
                             {sifim_tt4,       0.341130} ];
                         
    indicador_if_tt4 = NovaSerie( TRIMESTRAL, ProjecaoContabil( if_contabil ));                     

    pibsvcif.dados(end) = pibsvcif.dados(end-4) * (1+indicador_if_tt4.dados(end)/100);

    pibsvcif_sa = AjustaSerie( pibsvcif );
    
    disp( sprintf('pibsvc IFinanceira t/t-4 %3.2f %%',...
        (pibsvcif.dados(end)/pibsvcif.dados(end-4)-1)*100 ));
    disp( sprintf('pibsvc IFinanceira t/t-1 %3.2f %%',...
        (pibsvcif_sa.dados(end)/pibsvcif_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end;

%% TRANSPORTE

if Calcula_PIBSVCTR
    
%     
%     pibsvctr.dados = ProjecaoInteranual( pibindtr, ind_transporte_tri );
%     pibsvctr_sa = AjustaSerie( pibsvctr );
% 
%     disp( sprintf('pibind IND_TRANSFORMACAO t/t-4 %3.2f %%',...
%         (pibsvctr.dados(end)/pibsvctr.dados(end-4)-1)*100 ));
%     disp( sprintf('pibind IND_TRANSFORMACAO t/t-1 %3.2f %%',...
%         (pibsvctr_sa.dados(end)/pibsvctr_sa.dados(end-1)-1)*100 ));
%     disp( '-------------------------------------------------------' );

end; 

%% COMERCIO

if Calcula_PIBSVCCO

%     if any(isnan(insumoscc.dados(M1:M3)))  
%        insumoscc.dados = ProjecaoSarima( insumoscc );      
%     end;

%     pibsvccop = ProjecaoInteranual( pibsvcco , ind_comercio_tri );
%     pibsvccop_sa = AjustaSerie( pibsvccop );
% 
%     disp( sprintf('pib SVC_COMERCIO t/t-4 %3.2f %%',...
%         (pibsvccop.dados(end)/pibsvccop.dados(end-4)-1)*100 ));
%     disp( sprintf('pib SVC_COMERCIO t/t-1 %3.2f %%',...
%         (pibsvccop_sa.dados(end)/pibsvccop_sa.dados(end-1)-1)*100 ));
%     disp( '-------------------------------------------------------' );

end;


%% Composicao do PIB Svc

if Calcula_PIBSVC

    pibsvc_cont.tipo = MODELOCONTABIL;
    pibsvc_cont.modelo = [  {pibsvcif,11.3/22.3}, ...
                            {pibsvctr,3.6/22.3}, ...
                            {pibsvcco,4.8/22.3}, ...                            
                         ];  

    ind_servicos = NovaSerie( TRIMESTRAL, ProjecaoContabil( pibsvc_cont ) );

%     if isnan(ind_industria.dados(T1))  
%        ind_industria.dados = ProjecaoSarima( ind_industria );      
%     end;

    pibsvcp = ProjecaoInteranual( pibsvc , ind_servicos );
    
    pibsvcp_sa =  AjustaSerie( pibsvc );

    disp( sprintf('pibind INDUSTRIAL t/t-4 %3.2f %',...
        (pibsvc.dados(end)/pibsvc.dados(end-4)-1)*100 ));
    disp( sprintf('pibind INDUSTRIAL t/t-1 %3.2f %',...
        (pibsvc_sa.dados(end)/pibsvc_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end;

% grava as series projetadas
%xlswrite( arqout, [ind_siup.dados ind_transforma_sa.dados ...
%    insumoscc.dados indicador_em.dados ind_industria.dados],'p_mensais');  
%xlswrite( arqout, [pibind.dados pibindtr.dados pibindem.dados ...
%    pibindcc.dados pibindsiup.dados],'p_trimestrais');





