% --------------------------------------
% pibind_projecao.m
% Projecao do PIB Industrial trimestral 
% fcbarbi 21 out 2013 
% --------------------------------------

clc; close all; clear all;

DefineConstantes;

Calcula_PIBINDEM = 1;
Calcula_PIBINDTR = 0;
Calcula_PIBINDCC = 1; 
Calcula_PIBINDSI = 1;
Calcula_PIBIND = Calcula_PIBINDEM & Calcula_PIBINDTR & Calcula_PIBINDCC & Calcula_PIBINDSI;

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
global MENSAL TRIMESTRAL;
global SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;
global NO_CHECK;

global config;
% ano e mes de inicio dos dados e ano, trimestre atual atual 
config = InicializaT(2003,1,2013,3); % 1996 PIB, 2004 EPE

global dir0;
% dir0 = 'C:\Users\07244260865\Documents\lab\gdp\';
%dir0 = 'C:\Users\fcbarbi\Google Drive\SPE\lab\gdp\';
dir0 = 'L:\Area Tecnica\Conjuntura\Projecoes e Parametros\PIB Trimestral\2013\2013T3\projecao\';
%dir0 = 'C:\Users\70785201149\Documents\MATLAB\';

disp( 'Carrega dados...' );
arqin = strcat( dir0, 'dados_pibind.xlsx');
arqout = strcat( dir0, 'projecoes_pibind.xlsx');

% trimestrais = CarregaDados( arqin,'PIB','B2:F72',TRIMESTRAL, NO_CHECK );

% pibind1996 = NovaSerie( TRIMESTRAL, trimestrais(:,1), 1996,1 );
% %pibind1996.dados = [ pibind1996.dados ; NaN ];
% 
% pibindem1996 = NovaSerie( TRIMESTRAL, trimestrais(:,2), 1996,1 );
% 
% pibindtr1996 = NovaSerie( TRIMESTRAL, trimestrais(:,3), 1996,1 );
% 
% pibindcc = NovaSerie( TRIMESTRAL, trimestrais(:,4), 1996,1 );
% 
% pibindsiup1996 = NovaSerie( TRIMESTRAL, trimestrais(:,5), 1996,1 );

trimestrais = CarregaDados( arqin,'PIB','B2:F72',TRIMESTRAL, NO_CHECK );
pibind = NovaSerie( TRIMESTRAL, trimestrais(:,1), 1996,1 );
pibindem = NovaSerie( TRIMESTRAL, trimestrais(:,2), 1996,1  );
pibindtr = NovaSerie( TRIMESTRAL, trimestrais(:,3), 1996,1  );
pibindcc = NovaSerie( TRIMESTRAL, trimestrais(:,4), 1996,1 );
pibindsiup = NovaSerie( TRIMESTRAL, trimestrais(:,5), 1996,1  );

mensais = CarregaDados( arqin,'mensais','B2:N130',MENSAL );
epe = NovaSerie( MENSAL, mensais(:,1) );  % dados sem backcasting

epe = NovaSerie( MENSAL, mensais(:,1) );
%epe = NovaSerie_( MENSAL, mensais(:,1), 'EFETIVO' );
epe.obs = 'http://www.epe.gov.br/';

ons = NovaSerie( MENSAL, mensais(:,2) );
ons.obs = 'http://www.ons.org.br/';

pim_tr = NovaSerie( MENSAL, mensais(:,3) );
pim_tr.obs = 'Indice do setor de Ind de Transformacao da PIM';
pim_tr.spec = SPEC_PIM;

fenabrave = NovaSerie( MENSAL, mensais(:,4) );

ici = NovaSerie( MENSAL, mensais(:,5) );
ici.obs = 'Indice de Confianca da Industria (IBRE/FGV)';

abcr = NovaSerie( MENSAL, mensais(:,6) );
abcr.obs = 'Veiculos Pesados da ABCR http://www.abcr.org.br/';

insumoscc = NovaSerie( MENSAL, mensais(:,7) );
insumoscc.obs = 'Insumos Tip Ccivil (PIM) - mensal';

pim1991 = CarregaDados( arqin,'PIM','B2:I274',MENSAL, NO_CHECK ); % nao verifica tamanho maximo
pim_em.obs = 'PIM extrativa mineral';
pim_em = NovaSerie( MENSAL, pim1991(:,3), 1991, 1 );
%pim_em.dados = [ pim_em.dados ; NaN ];
pim_em.spec = SPEC_PIM;

pim_pg.obs = 'PIM petrolego e gas';
pim_pg = NovaSerie( MENSAL, pim1991(:,4), 1991, 1 );
pim_pg.spec = SPEC_PIM;

pim_fe.obs = 'PIM minerio de ferro';
pim_fe = NovaSerie( MENSAL, pim1991(:,5), 1991, 1 );
pim_fe.spec = SPEC_PIM;

pim_cm.obs = 'PIM carvao mineral';
pim_cm = NovaSerie( MENSAL, pim1991(:,6), 1991, 1 );
pim_cm.spec = SPEC_PIM;

pim_mnf.obs = 'PIM Minerais metalicos nao-ferrosos';
pim_mnf = NovaSerie( MENSAL, pim1991(:,7), 1991, 1 );
pim_mmf.spec = SPEC_PIM;

pim_nm.obs = 'PIM Minerais nao-metalicos';
pim_nm = NovaSerie( MENSAL, pim1991(:,8), 1991, 1 );
pim_nm.spec = SPEC_PIM;

% controle de tempo, converte de relativo em posicao absoluta
T1 = AnoTrimestre(config.ano,config.trimestre);
M1 = AnoMes(config.ano,config.m1); M2 = M1+1; M3 = M2+1;
ctem = NovaSerie( MENSAL, ones(M3,1) ); % constante mensal dos modelos 

d_2003_01 = DummyM( 2003,01 );
d_2008_12 = DummyM( 2008,12 );

disp( '-------------------------------------------------------' );

%% SIUP
%disp( 'Processando SIUP...' );

if Calcula_PIBINDSI

%lepe_sa = NovaSerie( MENSAL, 100*log( AjusteSazonal( epe ) ) );
lepe_sa = AjustaSerie( epe );
lepe_sa.dados = 100*log( lepe_sa.dados );
lepe_saL1 = LagSerie( lepe_sa,1 );

lons_sa = AjustaSerie( ons );
lons_sa.dados = 100*log( lons_sa.dados );
lons_saL1 = LagSerie( lons_sa,1 );
dlons_sa = DiffSerie( lons_sa );

siup_contabil.tipo = MODELOCONTABIL;
siup_contabil.obs = 'Modelo Contabil com pessos de EQ_EPE_2 (Eviews)';
siup_contabil.modelo = [ {ctem,3.768331},...
                         {lepe_saL1,0.319224},...
                         {lons_sa,0.391824},...
                         {lons_saL1,0.346706} ];

ind_siup_sa = NovaSerie( MENSAL, ProjecaoContabil( siup_contabil ));                     
%ind_siup_sa = ProjecaoContabil_( siup_contabil );

if any(isnan(ind_siup_sa.dados(M1:M3)))  
   ind_siup_sa.dados = ProjecaoSarima( ind_siup_sa );      
   %ind_siup_sa = ProjecaoSarima_( ind_siup_sa );      
end;

% variacao de x em log eh x2-x1, variacao de exp(x) eh x2/x1-1
ind_siup_sa.dados = exp( ind_siup_sa.dados/100 );
%ind_siup = DesAjusteSazonal( ind_siup_sa, epe );
ind_siup = DesAjustaSerie( ind_siup_sa, epe );

ind_siup_tri = TrimestralizaSerie( ind_siup );
pibindsiupp = ProjecaoInteranual( pibindsiup, ind_siup_tri );
%pibindsiup1996.dados(end) = pibindsiup.dados(end);

%pibindsiup1996_sa = NovaSerie( TRIMESTRAL, AjusteSazonal( pibindsiup1996 ) );
pibindsiupp_sa = AjustaSerie( pibindsiupp );

disp( sprintf('Indicador IND_SIUP M1 t/t-1 %3.2f %%',...
    (ind_siup_sa.dados(M1)/ind_siup_sa.dados(M1-1)-1)*100 ));
disp( sprintf('Indicador IND_SIUP M2 t/t-1 %3.2f %%',...
    (ind_siup_sa.dados(M2)/ind_siup_sa.dados(M2-1)-1)*100 ));
disp( sprintf('Indicador IND_SIUP M3 t/t-1 %3.2f %%',...
    (ind_siup_sa.dados(M3)/ind_siup_sa.dados(M3-1)-1)*100 ));
disp( ' ' );
disp( sprintf('pibind SIUP t/t-4 %3.2f %%',...
    (pibindsiupp.dados(end)/pibindsiupp.dados(end-4)-1)*100 ));
disp( sprintf('pibind SIUP t/t-1 %3.2f %%',...
    (pibindsiupp_sa.dados(end)/pibindsiupp_sa.dados(end-1)-1)*100 ));
disp( '-------------------------------------------------------' );

end;

%% TRANSFORMACAO 
%disp( 'Processando TRANSFORMACAO...' );

if Calcula_PIBINDTR
        
    pim_tr_sa = AjustaSerie( pim_tr );
    lpim_tr_sa = pim_tr_sa; lpim_tr_sa.dados = 100*log( lpim_tr_sa.dados );
    dlpim_tr_sa = DiffSerie( lpim_tr_sa );
    lpim_tr_saL1 = LagSerie( dlpim_tr_sa,1 );
    
    %pim_tr_sa.dados = 100*pim_tr_sa.dados;
    %dlpim_tr_sa = DLogSerie( pim_tr_sa );
    
    lici_sa = AjustaSerie( ici );
    lici_sa.dados = 100*log( lici_sa.dados );  
    dlici_sa = DiffSerie( lici_sa ); 
    
    lons_sa = AjustaSerie( ons );
    lons_sa.dados = 100*log( lons_sa.dados );
    lons_saL1 = LagSerie( lons_sa,1 );
    dlons_sa = DiffSerie( lons_sa );

    lfenabrave_sa = AjustaSerie( fenabrave );
    lfenabrave_sa.dados = 100*log( lfenabrave_sa.dados );
    lfenabrave_saL1 = LagSerie( lfenabrave_sa,1 );
    dlfenabrave_saL1 = DiffSerie( lfenabrave_saL1 );
   
    labcr_sa = AjustaSerie( abcr );
    labcr_sa.dados = 100*log( labcr_sa.dados );
    labcr_saL1 = LagSerie( labcr_sa,1 );
    dlabcr_saL1 = DiffSerie( labcr_saL1 );

    % C	0.206244
    % D(LICI_SA)	21.79211
    % D(LFENABRA_SA(-1))	3.727980
    % D_2003_1	-3.680620
    % D_2008_12	-8.790313
    % D(LO_NS_SA)	16.72665
    % D(LABCR_SA(-1))	-13.95459
    % AR(1)	-0.439520

    transf_cont.tipo = MODELOCONTABIL;
    transf_cont.obs = 'ver eq05_pim_trans_level no Eviews';
    transf_cont.modelo = [  {ctem,0.206244 }, ...
                            {dlici_sa,21.79211}, ...
                            {dlfenabrave_saL1,3.727980}, ...
                            {d_2003_01,-3.680620}, ...
                            {d_2008_12,-8.790313}, ...
                            {dlons_sa,16.72665}, ...
                            {dlabcr_saL1,-13.95459},...
                            {lpim_tr_saL1,-0.439520} ];

    dlpim_tr_sa = NovaSerie( MENSAL, ProjecaoContabil( transf_cont ) );
    
    for t=M1:M3
        if isnan(pim_tr_sa.dados(t))
            pim_tr_sa.dados(t) = exp( dlpim_tr_sa.dados(t) ) * pim_tr_sa.dados(t-1);
        end;
    end;    
        
    if any(isnan(pim_tr_sa.dados(M1:M3)))  
       pim_tr_sa.dados = ProjecaoSarima( pim_tr_sa );      
    end;

    ind_transforma_sa_tri = TrimestralizaSerie( pim_tr_sa );
    ind_transforma_tri = DesAjustaSerie( ind_transforma_sa_tri, pibindtr );
    
    pibindtrp = ProjecaoInteranual( pibindtr, ind_transforma_tri );
    %pibindtr1996.dados(end) = pibindtr.dados(T1);
    pibindtrp_sa = AjustaSerie( pibindtrp );

    disp( sprintf('Indicador IND_TRANSFORMACAO M1 t/t-1 %3.2f %%',...
        (ind_transforma_sa.dados(M1)/ind_transforma_sa.dados(M1-1)-1)*100 ));
    disp( sprintf('Indicador IND_TRANSFORMACAO M2 t/t-1 %3.2f %%',...
        (ind_transforma_sa.dados(M2)/ind_transforma_sa.dados(M2-1)-1)*100 ));
    disp( sprintf('Indicador IND_TRANSFORMACAO M3 t/t-1 %3.2f %%',...
        (ind_transforma_sa.dados(M3)/ind_transforma_sa.dados(M3-1)-1)*100 ));
    disp( ' ' );
    disp( sprintf('pibind IND_TRANSFORMACAO t/t-4 %3.2f %%',...
        (pibindtrp.dados(end)/pibindtrp.dados(end-4)-1)*100 ));
    disp( sprintf('pibind IND_TRANSFORMACAO t/t-1 %3.2f %%',...
        (pibindtrp_sa.dados(end)/pibindtrp_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end; 

%% CCIVIL 

% TODO: definir um modelo contabil para CC ******

if Calcula_PIBINDCC

    if any(isnan(insumoscc.dados(M1:M3)))  
       insumoscc.dados = ProjecaoSarima( insumoscc );      
    end;

    %insumoscc_sa = NovaSerie( MENSAL, AjusteSazonal( insumoscc ));
    insumoscc_sa = AjustaSerie( insumoscc );

    insumoscc_tri = TrimestralizaSerie( insumoscc );

    pibindccp = ProjecaoInteranual( pibindcc , insumoscc_tri );
    %pibindcc1996.dados(end) = pibindcc.dados(T1);
    
    pibindccp_sa = AjustaSerie( pibindccp );

    disp( sprintf('Indicador IND_CCIVIL M1 t/t-1 %3.2f %%',...
        (insumoscc_sa.dados(M1)/insumoscc_sa.dados(M1-1)-1)*100 ));
    disp( sprintf('Indicador IND_CCIVIL M2 t/t-1 %3.2f %%',...
        (insumoscc_sa.dados(M2)/insumoscc_sa.dados(M2-1)-1)*100 ));
    disp( sprintf('Indicador IND_CCIVIL M3 t/t-1 %3.2f %%',...
        (insumoscc_sa.dados(M3)/insumoscc_sa.dados(M3-1)-1)*100 ));
    disp( ' ' );
    disp( sprintf('pibind CCIVIL t/t-4 %3.2f %%',...
        (pibindccp.dados(end)/pibindccp.dados(end-4)-1)*100 ));
    disp( sprintf('pibind CCIVIL t/t-1 %3.2f %%',...
        (pibindccp_sa.dados(end)/pibindccp_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end;

%% EXTRATIVA MINERAL 
   
if Calcula_PIBINDEM

    % Testa se ajuste esta funcionando
    %pim_em_sa = AjustaSerie( pim_em )
    %pim_em_sad = DesAjustaSerie( pim_em_sa,pim_em )
    %Se tudo ok, pim_em_sad deve ser igual a pim_em
    %[pim_em.dados pim_em_sa.dados pim_em_sad.dados]
    
    % todas estas series vem desde jan 1991
    pim_em.dados = ProjecaoSarima( pim_em );
    pim_pg.dados = ProjecaoSarima( pim_pg );
    pim_fe.dados = ProjecaoSarima( pim_fe );
    pim_cm.dados = ProjecaoSarima( pim_cm );
    pim_mnf.dados = ProjecaoSarima( pim_mnf );
    pim_nm.dados = ProjecaoSarima( pim_nm );

    em_contabil.tipo = MODELOCONTABIL;
    em_contabil.modelo = [  {pim_pg,0.52}, ...
                            {pim_fe,0.35}, ...
                            {pim_cm,0.01}, ...
                            {pim_mnf,0.05}, ...
                            {pim_nm,0.08} ];

    % depois de truncado para 01/2003 indicador tambem comeca em 01/1991
    indicador_em1991 = NovaSerie( MENSAL, ProjecaoContabil( em_contabil ), 1991,1 );

    % traz indicador_em para 01/2003 como as demais series mensais
    indicador_em = TruncaSerie( indicador_em1991 );
        
    indicador_em_tri = TrimestralizaSerie( indicador_em );

    pibindemp = ProjecaoInteranual( pibindem , indicador_em_tri );
    
    %pibindem1996.dados(end) = pibindem.dados(T1);    
    pibindemp_sa = AjustaSerie( pibindemp );
    
%     pibindem1996_sa = NovaSerie( TRIMESTRAL, AjusteSazonal( pibindem1996 ) );
%     disp( sprintf('Indicador IND_EXTRATIVA_MINERAL M1 t/t-1 %3.2f %%',...
%         (indicador_em_sa.dados(M1)/indicador_em_sa.dados(M1-1)-1)*100 ));
%     disp( sprintf('Indicador IND_EXTRATIVA_MINERAL M2 t/t-1 %3.2f %%',...
%         (indicador_em_sa.dados(M2)/indicador_em_sa.dados(M2-1)-1)*100 ));
%     disp( sprintf('Indicador IND_EXTRATIVA_MINERAL M3 t/t-1 %3.2f %%',...
%         (indicador_em_sa.dados(M3)/indicador_em_sa.dados(M3-1)-1)*100 ));
%     disp( ' ' );

    disp( sprintf('pibind EXTRATIVA_MINERAL t/t-4 %3.2f %%',...
        (pibindemp.dados(end)/pibindemp.dados(end-4)-1)*100 ));
    disp( sprintf('pibind EXTRATIVA_MINERAL t/t-1 %3.2f %%',...
        (pibindemp_sa.dados(end)/pibindemp_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end;

%% Composicao do PIB industrial

if Calcula_PIBIND

    pibind_cont.tipo = MODELOCONTABIL;
    pibind_cont.modelo = [  {pibindtr,11.3/22.3}, ...
                            {pibindem,3.6/22.3}, ...
                            {pibindcc,4.8/22.3}, ...
                            {pibindsiup,2.6/22.3} ... 
                         ];  

    ind_industria = NovaSerie( TRIMESTRAL, ProjecaoContabil( pibind_cont ) );

    if isnan(ind_industria.dados(T1))  
       ind_industria.dados = ProjecaoSarima( ind_industria );      
    end;

    pibindp = ProjecaoInteranual( pibind, ind_industria );
    
    %pibind1996.dados(end) = pibind.dados(T1);
    %pibind1996_sa =  NovaSerie( TRIMESTRAL, AjusteSazonal( pibind1996 ));
    
    pibindp_sa =  AjustaSerie( pibindp );

    disp( sprintf('pibind INDUSTRIAL t/t-4 %3.2f %',...
        (pibindp.dados(end)/pibindp.dados(end-4)-1)*100 ));
    disp( sprintf('pibind INDUSTRIAL t/t-1 %3.2f %',...
        (pibindp_sa.dados(end)/pibindp_sa.dados(end-1)-1)*100 ));
    disp( '-------------------------------------------------------' );

end;

% grava as series projetadas
%xlswrite( arqout, [ind_siup.dados ind_transforma_sa.dados ...
%    insumoscc.dados indicador_em.dados ind_industria.dados],'p_mensais');  
%xlswrite( arqout, [pibind.dados pibindtr.dados pibindem.dados ...
%    pibindcc.dados pibindsiup.dados],'p_trimestrais');





