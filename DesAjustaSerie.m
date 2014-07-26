function sobj = DesAjustaSerie( sobja, sref );
% Aplica o fator sazonal de volta para voltar a serie sem ajuste sazonal.
% Usa os fatores szonais da serie sref.
% ---------------------------------------------------
% Exemplo de Uso:
% ind_siup = DesAjusteSazonal( ind_siup_sa, epe );
% Nome antigo era DesAjusteSazonal()
% ---------------------------------------------------

global TRIMESTRAL MENSAL config;

%sobja = ind_siup_sa; sref = epe;

sref_sa = AjusteSazonal( sref );

fator_sazonal = sref.dados ./ sref_sa;

if (sobja.freq==MENSAL)
    offset = 12;
    T = AnoMes(config.ano,config.m3); 
end;

if (sobja.freq==TRIMESTRAL)
    offset = 4;
    T = AnoTrimestre(config.ano,config.trimestre); 
end; 

% se faltar algum FS preenche com o do mesmo periodo do ano anterior
i = 0;
while isnan(fator_sazonal(T-i))
   fator_sazonal(T-i) = fator_sazonal(T-i-offset);
   i = i+1;
end; 

sobj = NovaSerie( sobja.freq, sobja.dados .* fator_sazonal );