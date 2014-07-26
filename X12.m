function [sajustado previsto]= X12( sobj )  % X12( sobj, spec )
% --------------------------------------
% Chama X12 para ajuste sazonal de series
% --------------------------------------
% PIB PM   A (2 1 0)(0 1 1)
% IBC-BR     (0 1 2)(0 1 1) d2008_dez,Car,Pas,TD
% PIM      ? (2 1 0)(0 1 2)
%
% --------------------------------------
% C:\MM\PIB_Dessazonalizado\x12a.exe C:\MM\PIB_Dessazonalizado\PIB  
% C:\MM\Dessaz\x12aV0.2.10.exe C:\MM\Dessaz\DESSAZ
% PIB.spc  % comandos para o x12 (input)
% PIB.d11  % serie ajustada (output)
% PIB.fct  % forecast (output)
% --------------------------------------
% fcbarbi 21 out 2013 
% --------------------------------------

global MENSAL TRIMESTRAL SPEC_PIB SPEC_IBCBR SPEC_PIM SPEC_PMC;
global config dir0;
status = -1;

%sobj = epe; spec = SPEC_IBCBR; % debug 

spec = sobj.spec;
% if (nargin==1)
%     if (sobj.freq==MENSAL)
%        spec = SPEC_IBCBR; 
%     end;
%     if (sobj.freq==TRIMESTRAL)
%        spec = SPEC_PIB; 
%     end;
% end;    

if (spec==SPEC_PIB) 
  dir = 'C:\MM\PIB_Dessazonalizado\';
  arq = 'PIB';  
  exe = 'x12a.exe';      
end;  

if (spec==SPEC_IBCBR) 
    dir = 'C:\MM\Dessaz\';
    arq = 'DESSAZ';        
    exe ='x12aV0.2.10.exe';    
    delete( strcat(dir,'Carn7625.dat') );
end;

if (spec==SPEC_PIM) 
    dir = 'C:\MM\PIM_Dessazonalizada\';
    arq = 'PIM';        
    exe ='x12aV0.2.10.exe';    
    delete( strcat(dir,'Carn7625.dat') );
end;

% apaga para nao ter o perido de trazer lixo do passado
delete( strcat(dir,arq,'.spc') );
delete( strcat(dir,arq,'.d11') );
delete( strcat(dir,arq,'.fct') ); 

% 1.monta arquivo arq1 com spec 
if (spec==SPEC_PIB)    
    fid = fopen( strcat(dir,arq,'.spc'),'wb' );
    fprintf(fid,'series{\n');
    fprintf(fid,'title="PIB"\n');
    fprintf(fid,strcat('start=',num2str(sobj.ano0),'.',...
        num2str(sobj.tri0),'\n'));  
    fprintf(fid,'period=4\n');
    fprintf(fid,'decimals=2\n');
    fprintf(fid,'data=(\n');
    for i=1:size(sobj.dados,1)
        % X12 WARNING: Automatic transformation selection cannot be done
        % on a series with zero or negative values
        if (~isnan(sobj.dados(i,1)) && sobj.dados(i,1)>0.0001) % ????
            fprintf( fid,'%8.2f\n',sobj.dados(i,1) );  % 3.12f
        else 
            if (sobj.dados(i,1)<0.0001) 
                error('X12(SPEC_PIB) chamado com valor negativo ou zero');
            end;    
        end;        
    end;    
    fprintf(fid,')}\n');
    fprintf(fid,'transform{function=auto}\n');
    fprintf(fid,'regression{aictest=(easter td)}\n');
    fprintf(fid,'pickmdl{identify=all method=best}\n');
    fprintf(fid,'outlier{types=all}\n');
    fprintf(fid,'forecast{maxlead=4 maxback=0 save=fct}\n');
    fprintf(fid,'x11{save=d11 savelog=q}\n');
    fclose(fid);
end;

if (spec==SPEC_IBCBR)    
    fid = fopen( strcat(dir,arq,'.spc'),'wb' );
    fprintf(fid,'series{\n');
    fprintf(fid,'title=" IBCBr "\n');    
    fprintf(fid,strcat('start=',num2str(sobj.ano0),'.',...
            num2str(sobj.mes0),'\n'));  % 'start=2003.1'); 
    fprintf(fid,'period=12\n');
    fprintf(fid,'decimals=2\n');
    fprintf(fid,'format="datevalue"\n');
    fprintf(fid,'data=(\n');
    for i=1:size(sobj.dados,1)
        % X12 WARNING: Automatic transformation selection cannot be done
        % on a series with zero or negative values
        if (~isnan(sobj.dados(i,1)) && sobj.dados(i,1)>0.0001) % ????
            fprintf( fid,'%8.2f\n',sobj.dados(i,1) );
        else 
            if (sobj.dados(i,1)<0.0001) 
                error('X12(SPEC_IBCBR) chamado com valor negativo ou zero');
            end;    
        end;        
    end;   
    fprintf(fid,')}\n');    
    fprintf(fid,'transform{function=auto}\n');
    fprintf(fid,'regression{variables = ( )\n');
    fprintf(fid,'aictest=(easter td)\n');
    fprintf(fid,'user = (Carnaval)\n');
    fprintf(fid,'usertype = holiday\n');
    fprintf(fid,'file="C:\\MM\\Dessaz\\Carn7625.dat"\n');
    fprintf(fid,'format="datevalue"\n');
    fprintf(fid,strcat('start=',num2str(sobj.ano0),'.',...
            num2str(sobj.mes0),'}\n'));  % 'start=2003.1');     
    %fprintf(fid,strcat('start=1999.1}\n'));    
    fprintf(fid,'automdl{ method=best file="C:\\MM\\Dessaz\\x12a.mdl"\n'); 
    fprintf(fid,'   identify=all outofsample=yes savelog=automodel }\n');
    fprintf(fid,'outlier{}\n');
    fprintf(fid,'estimate{maxiter=900}\n');
    fprintf(fid,'forecast{maxlead=12 maxback=0 save=fct}\n');
    fprintf(fid,'x11{save=(d11) appendfcst=yes savelog=(ids)}\n');
    fclose(fid);
end;

if (spec==SPEC_PIM)        
    fid = fopen( strcat(dir,arq,'.spc'),'wb' );
    fprintf(fid,'series{\n');
    fprintf(fid,'title=" PIM "\n');
    %fprintf(fid,strcat('start=2003.1');     
    fprintf(fid,strcat('start=',num2str(sobj.ano0),'.', num2str(sobj.mes0),'\n'));  
    fprintf(fid,'period=12\n');
    fprintf(fid,'decimals=2\n');
    fprintf(fid,'data=(\n');    
    
    anofinal = config.ano;
    mesfinal = config.m3;
    
    for i=1:size(sobj.dados,1)
        % X12 WARNING: Automatic transformation selection cannot be done
        % on a series with zero or negative values
        if isnan(sobj.dados(i,1))          
          if (mesfinal==1)
            mesfinal = 12;
            anofinal = anofinal-1;
          else     
            mesfinal = mesfinal-1;  
          end;            
        end;    
        if (~isnan(sobj.dados(i,1)) && sobj.dados(i,1)>0.0001) % ????
            fprintf( fid,'%8.2f\n',sobj.dados(i,1) );
        else 
            if (sobj.dados(i,1)<0.0001) 
                error('X12(SPEC_PIM) chamado com valor negativo ou zero');
            end;    
        end;        
    end;  
    fprintf(fid,')\n');
    fprintf(fid,'format="(f6.2)"\n');
    %fprintf(fid,'span=(2003.1,2013.7)\n');
    fprintf(fid, strcat('span=(',num2str(sobj.ano0),'.',num2str(sobj.mes0),',',num2str(anofinal),'.',num2str(mesfinal),')\n') );
    %fprintf(fid,'modelspan=(2003.1,2013.7)\n');
    fprintf(fid, strcat('modelspan=(',num2str(sobj.ano0),'.',num2str(sobj.mes0),',',num2str(anofinal),'.',num2str(mesfinal),')\n') );
    fprintf(fid,'}\n');
    fprintf(fid,'transform{function=None}\n');
    fprintf(fid,'regression{variables = ( )\n');
    fprintf(fid,'aictest=(easter td)\n');
    fprintf(fid,'user = (Carnaval)\n');
    fprintf(fid,'usertype = holiday\n');
    %fprintf(fid,'file="C:\MM\PIM_Dessazonalizada\Carn7625.dat"\n');
    %fprintf(fid, strcat('file="',dir,'Carn7625.dat"\n') );
    fprintf(fid,'file="C:\\MM\\PIM_Dessazonalizada\\Carn7625.dat"\n');
        fprintf(fid,'format="datevalue"\n');
    %fprintf(fid,'start=2003.1\n');
    fprintf(fid,strcat('start=',num2str(sobj.ano0),'.', num2str(sobj.mes0),'\n'));  
    fprintf(fid,'}\n');
    fprintf(fid,'arima{model=(2 1 0)(0 1 2)}\n');
    fprintf(fid,'forecast{maxlead=12 maxback=0 save=fct}\n');    
    fprintf(fid,'outlier{types=all}\n');
    fprintf(fid,'estimate{maxiter=900}\n');
    fprintf(fid,'x11{appendfcst=yes save=(d11) savelog=(ids)}\n'); %(d11 e18)    
    fclose(fid);
end;

% grava arquivo dos meses do Carnaval
if (spec==SPEC_IBCBR || spec==SPEC_PIM)   
    load( strcat(dir0,'carnaval') );
    fid = fopen( strcat(dir,'Carn7625.dat'),'wb' );
    i=1; prossegue=1;
    while (prossegue)         
        % um ano adicional para previsao
         if (carnaval(i,1)>=sobj.ano0 || ...
               (carnaval(i,1)==config.ano+1 && carnaval(i,2)<=config.mes))            
            fprintf( fid,'%i \t %i \t %i \t \n',...
                carnaval(i,1),carnaval(i,2),carnaval(i,3) );  
         end;  
        i=i+1;            
        if (i==size(carnaval,1)) prossegue=0; end;
    end;     
    fclose(fid);
end;    

sajustado = NovaSerie( sobj.freq, [] );
previsto = [];

% 2.chama X12 e verifica status de retorno
comando = [ strcat(dir,exe) ' ' strcat(dir,arq) ]; % ,'.spc'
[status,result] = system( comando );

% 3.le conteudo dos arquivos de retorno (inlusive erros em .err)
% Conteudo de PIB.d11
% date	PIB.d11
% ------	-----------------------
% 199601	+0.102744848070808E+03
% 199602	+0.103029049444189E+03

% 4.le conteudo do arquivo de previsao 
% Conteudo de PIB.fct
% date	forecast	lowerci	upperci
% ------	----------------------	----------------------	------
% 201304	+0.207355974210912E+03	+0.203237202360148E+03	+0.211...

if (status==0) % ok 
    retorno = [];
    retorno = dlmread( strcat(dir,arq,'.d11'),'\t',2,1 ); 
    %if ~isempty(retorno)
        sajustado.dados = retorno; 
    %end;
    retorno = [];
    retorno = dlmread( strcat(dir,arq,'.fct'),'\t',2,1 );    
    %if ~isempty(retorno)
        previsto = retorno(:,1); % so primeira coluna 
    %end;    
else 
   error( strcat('AjusteSazonal() falhou com serie ',sobj.obs) ); 
end;

% retorna serie com o mesmo tamanho da que foi passada
if size(sajustado.dados,1)<size(sobj.dados,1)
  sajustado.dados = [ sajustado.dados ; ...
      repmat([NaN],size(sobj.dados,1)-size(sajustado.dados,1),1) ];
end;  




