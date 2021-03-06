function [ajacinv,det,c]=jacinv(ajac)
%****************************************************
%*                                                  *
%*      Forms the Inverse of the Jacobian           *
%*                                                  *
%****************************************************
%
      
    c=zeros(3,3);
    c(1,1)=ajac(2,2)*ajac(3,3)-ajac(2,3)*ajac(3,2) ;
    c(1,2)=-(ajac(2,1)*ajac(3,3)-ajac(2,3)*ajac(3,1)) ;
    c(1,3)=ajac(2,1)*ajac(3,2)-ajac(2,2)*ajac(3,1) ;
    c(2,1)=-(ajac(1,2)*ajac(3,3)-ajac(1,3)*ajac(3,2)) ;
    c(2,2)=ajac(1,1)*ajac(3,3)-ajac(1,3)*ajac(3,1) ;
    c(2,3)=-(ajac(1,1)*ajac(3,2)-ajac(1,2)*ajac(3,1)) ;
    c(3,1)=ajac(1,2)*ajac(2,3)-ajac(1,3)*ajac(2,2) ;
    c(3,2)=-(ajac(1,1)*ajac(2,3)-ajac(1,3)*ajac(2,1)) ;
    c(3,3)=ajac(1,1)*ajac(2,2)-ajac(1,2)*ajac(2,1) ;
    
    % Calculate the Determinant of the Jacobian
    det=0.0 ;
    for i=1:3,
        det=det+ajac(1,i)*c(1,i) ;
    end
    
    % Forms the Inverse of the Jacobian
    ajacinv=zeros(3,3);
    for i=1:3,
        for j=1:3,
            ajacinv(i,j)=c(j,i)/det ;
        end
    end
end