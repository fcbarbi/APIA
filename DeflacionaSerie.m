function s_real = DeflacionaSerie( s_nominal, s_precos, ajusta_base )
% --------------------------------------
% deflaciona serie de valores nominais por indice de precos (base fixa)
% Por ex: se a serie de valores nominais n1 para obter volumes v1
% fazemos v1 = n1/(p1/p0) = n1*p0/p1, v2 = n2*p0/p2, (p0 fixo)
% Note que os precos sao calculados com base p0=100 se ajusta_base=1
% mas ajusta_base eh opcional, deve ser 0 (default) ou 1.
% --------------------------------------
% fcbarbi set/out 2013 

BASE_INDICE = 100; % cte definida aqui pq so usada aqui

s_real = NovaSerie( s_nominal.freq, [] );
s_real.dados(1,:) = s_nominal.dados(1,:);

if ( (s_nominal.freq ~= s_precos.freq) || (size(s_nominal,1) ~= size(s_precos,1)) )
    error('DeflacionaFixo():Frequencia e qtde de dados devem ser iguais nas duas series.');
end;    

% ajusta a base para preco=BASE_INDICE na primeira observacao
if (nargin<3) 
   ajusta_base = 0;  % por default nao ajuste a base de precos para 100
end;
if (ajusta_base)
    valor_base = s_precos.dados(1);
    s_precos.dados(1:end,1) = BASE_INDICE*s_precos.dados(1:end,1)/valor_base;
end;    

[l c] = size(s_nominal.dados);
for i=2:l
    for j=1:c
        s_real.dados(i,j) = s_nominal.dados(i,j)*s_precos.dados(1,1)/s_precos.dados(i,1);
    end;    
end;    

