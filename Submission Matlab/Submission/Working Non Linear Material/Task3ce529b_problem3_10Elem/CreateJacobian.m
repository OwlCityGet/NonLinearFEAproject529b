function [ajac]=CreateJacobian(dhdr,dhdn,dhds,x,y,z)

ajac(1,1)=dhdr'*x;
ajac(1,2)=dhdr'*y;
ajac(1,3)=dhdr'*z;

ajac(2,1)=dhdn'*x;
ajac(2,2)=dhdn'*y;
ajac(2,3)=dhdn'*z;

ajac(3,1)=dhds'*x;
ajac(3,2)=dhds'*y;
ajac(3,3)=dhds'*z;

end
