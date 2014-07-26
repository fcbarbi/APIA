function st = Trimestraliza( sm )
% retorna serie com a media trimestral de uma serie mensal 
% a ultima observacao so pode ser a media de 1, 2 ou 3 meses 

 global SERIE MENSAL TRIMESTRAL;
 %DEBUG %cx = 1; %lx = 99; % lx = 100; %lx = 101; %x = rand(lx,1);
 erro = 0; % no error
 
 if ~isnumeric(sm.dados) || all(isnan(sm.dados))
     error('Trimestraliza(): Erro na serie passada');
 end;
 
 %if ~(x.tipo==SERIE && x.freq==MENSAL)
 if ~(sm.freq==MENSAL)     
     erro=-1;
     error('Trimestraliza() so pode ser chamada com serie mensal.');
 end;    
 
 [lx cx]=size(sm.dados); 
 %calculada = zeros(floor(lx/3),cx); 
 ix = 1; % indice para serie x.dados
 ixt = 1; 
 
 while (ix<=floor(lx/3)*3)
   calculada(ixt,:) = (sm.dados(ix,:)+sm.dados(ix+1,:)+sm.dados(ix+2,:))/3;
   ixt = ixt+1;
   ix  = ix+3;
 end;

 if ((lx-floor(lx/3)*3)==2)
   calculada(ixt,:) = (sm.dados(ix,:)+sm.dados(ix+1,:))/2;  
 end;
 
 if ((lx-floor(lx/3)*3)==1)
    calculada(ixt,:) = sm.dados(ix,:); 
 end;
 
 st = NovaSerie( TRIMESTRAL, calculada );
 %st_dados = calculada;

