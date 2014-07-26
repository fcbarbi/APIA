function DefineConstantes

% constantes de uso em varias funcoes
global SERIE MODELOCONTABIL MODELOESTATISTICO;
SERIE = 1;
MODELOCONTABIL = 2;    
MODELOESTATISTICO = 3; 

global ANUAL MENSAL TRIMESTRAL;
MENSAL = 1;
TRIMESTRAL = 3;
ANUAL = 12;

global NO_SPEC SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;
NO_SPEC = 0;  % series anuais nao tem spec
SPEC_PIB = 1;
SPEC_IBCBR = 2;
SPEC_PIM = 3;
SPEC_PMC = 4;

global CHECK NO_CHECK;
CHECK = 1;
NO_CHECK = 0;  % Carregadados()