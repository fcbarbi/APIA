
% simula_var.m
% Simula VAR

MAXLIN=10;
MAXCOL=3;

x = randn(MAXLIN,MAXCOL);  % 10x3
beta0 = [2 3 0.1]';   % 3x1
   
xL = [repmat( NaN,1,MAXCOL ); x(1:end-1,:)]; 
y = xL*beta0;
beta = regress(y,xL);



