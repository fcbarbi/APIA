% --------------------------------------
% Demonstra.m
% Demostra biblioteca para projecao de curto prazo do PIB trimestral 
% fcbarbi MF/SPE Out 2013
% --------------------------------------
%
% Documentar:
%   Inicializa()    
%   DefineConstantes()
%   CarregaDados()
%   NovaSerie()
%   SomaSeries()
%   MultiplicaSeries()
%   DeflacionaFixo()
%   AnoMes()
%   AnoTrimestre()
%   Trimestraliza()
%   ProjecaoInteranual()
%   ProjecaoContabil()
%   ProjecaoSarima()
%   AjusteSazonal()
%   DesAjusteSazonal()
%   LagSerie()
%   X12() eh chamada por AjusteSazonal() e ProjecaoSarima()
%
% --------------------------------------
% fcbarbi 16.10.2013 
% --------------------------------------

clc;clear all;
DefineConstantes;

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
global MENSAL TRIMESTRAL;
global SPEC_PIB SPEC_IBCBR;

% ano e mes de inicio dos dados, ano e trimestre atual 
global config;
%config = Inicializa(1996,1,2013,3);
config = Inicializa(2003,1,2013,3);

% carrega dados 
% load demodata;  % debug

dir = 'C:\Users\07244260865\Documents\lab\gdp\';
%dir = 'C:\Users\fcbarbi\Google Drive\SPE\lab\gdp\';
arqin = strcat( dir, 'demo.xlsx');
arqout = strcat( dir, 'projecoes.xlsx');
mensais = CarregaDados( arqin,'mensais','C2:G130',MENSAL );
trimestrais = CarregaDados( arqin,'trimestrais','C2:D43',TRIMESTRAL );

% debug 
% rand('seed',10); T = 213;  % simula serie com T meses de obs 

x0 = NovaSerie( MENSAL, mensais(:,1) );
x0.obs = 'Documente aqui a serie (origem,formula,etc...)';

x1 = NovaSerie ( MENSAL, mensais(:,2) );
x2 = NovaSerie( MENSAL, mensais(:,3) );

x012 = MultiplicaSeries( x0,x1,x2 );

x2.dados( AnoMes(config.ano,config.m3) ) = NaN;  % simula falta de dado
x2p = NovaSerie ( TRIMESTRAL, ProjecaoInteranual( x2, x1 ) );  

x3 = SomaSeries( x0, x1, x2 );
if isempty(x3.dados) disp('Erro em SomaSeries()!'); end; 

precos = NovaSerie( MENSAL, mensais(:,4) );
x5 = NovaSerie( MENSAL, mensais(:,5) );

x2r = DeflacionaFixo( x2,precos );
%x2r0 = DeflacionaFixo( x2,precos,1 );
%xlswrite( arqout, [x2r.dados x2r0.dados],'deflaciona');

disp('O valor do primeiro mes deste trimestre eh = '),
disp( x2.dados( AnoMes( config.ano, config.m1 ) ));

x2L1 = LagSerie( x2,1 );

% x3p é um indicador mensal calculado como x3 = 0.8*x1 + 0.2*x2;
modelo_x3_contabil.tipo = MODELOCONTABIL;
%modelo_x3_contabil.modelo = [{x1,0.8},{x2,0.3}];  % ERRO soma dos pesos
%modelo_x3_contabil.modelo = [{x1,0.8},{x2,0.2},{x0}]; % ERRO falta peso
modelo_x3_contabil.modelo = [{x1,0.6},{x2,0.1},{x2L1,0.3}];  

% tenta fazer projecao contabil antes de usar projecao estatitica 
x3p = NovaSerie( MENSAL,ProjecaoContabil( modelo_x3_contabil ) );
M1 = AnoMes(config.ano,config.m1);
if any(isnan(x3p.dados(M1:M1+2)))  
   x3p.dados = ProjecaoSarima( x3p );      
end;

x3t = Trimestraliza( x3p );
% Se tentar somar series com frequencias diferentes gera erro!
% x13 = SomaSeries( x1,x3t );
% if isempty(x3.dados)
%    error('series de tipos diferentes!');
% end;
disp('O valor do ultima obs trimestral de x3t eh = '),
disp( x3t.dados( AnoTrimestre( config.ano, config.trimestre ) ))

% Ajuste sazonal serie mensal 
x3a = AjusteSazonal( x3 ); % , SPEC_IBCBR
x3ad = DesAjusteSazonal( x3a, x3 );

x4 = NovaSerie ( TRIMESTRAL, trimestrais(:,1) );
x4p = NovaSerie ( TRIMESTRAL, ProjecaoInteranual( x4, x3t ) );  

% Ajuste sazonal serie trimestral
x4pa = AjusteSazonal( x4p ); %, SPEC_PIB );

% *** EM TESTE ***
% Exemplo de ajuste manual da serie 
% Assumindo x5 ajustado sazonalmente podemos fazer variacao t/t-1
x5 = NovaSerie ( TRIMESTRAL, trimestrais(:,2) );
x5.dados( AnoMes(config.ano,config.m1) ) = AnoMes(config.ano,config.m1-1)*1.01;  
x5.dados( AnoMes(config.ano,config.m2) ) = AnoMes(config.ano,config.m1)*1.02;
x5.dados( AnoMes(config.ano,config.m3) ) = NaN;
x5p.dados = ProjecaoInteranual( x5, x3t );

% Adicionar suporte a multiplas series 
% x5pa = AjusteSazonal( x5p, SPEC_PIB );

xlswrite( arqout, [x0.dados x1.dados x2.dados x3.dados],'x0x3'); % x3a.dados
xlswrite( arqout, [x3t.dados],'x3t');
xlswrite( arqout, [x4.dados],'x4');
xlswrite( arqout, [x4p.dados],'x4p');
%xlswrite( arqout, [x4pa.dados],'x4pa');
xlswrite( arqout, [x5.dados],'x5');  
xlswrite( arqout, [x5p.dados],'x5p');
%xlswrite( arqout, [x5pa.dados ],'x5pa');  




