a=[2*10^-4/3+0.02673 -2*10^-4/3 0.05;
    -2*10^-4/3 1600*10^-4/6+0.0267 -0.05;
    0.05 -0.05 0];
b=[0.001 0 0]';
sol=inv(a)*b;
fun=@(r,n)0.25*(1-r)*(1+n)*(r+n-1);
g=integral2(fun,-1,1,-1,1)

