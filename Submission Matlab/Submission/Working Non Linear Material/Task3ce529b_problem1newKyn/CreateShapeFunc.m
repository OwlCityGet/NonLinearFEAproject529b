function [shapeF,dhdr,dhdn,dhds]=CreateShapeFunc(r,n,s,nNodes)
    % Create the Shape function evaluated at r,n,s and their derivatives
    if nNodes == 20
        shapeF=zeros(20,1);
        shapeF(1,1)=1/8*(1-r)*(1-n)*(1-s)*(-r-n-s-2);
        shapeF(2,1)=1/8*(1+r)*(1-n)*(1-s)*(r-n-s-2);
        shapeF(3,1)=1/8*(1+r)*(1+n)*(1-s)*(r+n-s-2); 
        shapeF(4,1)=1/8*(1-r)*(1+n)*(1-s)*(-r+n-s-2);
        shapeF(5,1)=1/8*(1-r)*(1-n)*(1+s)*(-r-n+s-2);
        shapeF(6,1)=1/8*(1+r)*(1-n)*(1+s)*(r-n+s-2);
        shapeF(7,1)=1/8*(1+r)*(1+n)*(1+s)*(r+n+s-2);
        shapeF(8,1)=1/8*(1-r)*(1+n)*(1+s)*(-r+n+s-2);
        %
        shapeF(9,1)=1/4*(1-r^2)*(1-n)*(1-s);
        shapeF(11,1)=1/4*(1-r^2)*(1+n)*(1-s);
        shapeF(13,1)=1/4*(1-r^2)*(1-n)*(1+s);
        shapeF(15,1)=1/4*(1-r^2)*(1+n)*(1+s);
        %
        shapeF(10,1)=1/4*(1+r)*(1-n^2)*(1-s);
        shapeF(12,1)=1/4*(1-r)*(1-n^2)*(1-s);
        shapeF(14,1)=1/4*(1+r)*(1-n^2)*(1+s);
        shapeF(16,1)=1/4*(1-r)*(1-n^2)*(1+s);
        %
        shapeF(17,1)=1/4*(1-r)*(1-n)*(1-s^2);
        shapeF(18,1)=1/4*(1+r)*(1-n)*(1-s^2);
        shapeF(19,1)=1/4*(1+r)*(1+n)*(1-s^2);
        shapeF(20,1)=1/4*(1-r)*(1+n)*(1-s^2);
        
        %Calculate the derivatives of the shape function w.r.t r
        dhdr(1,1)=1/8*(1-n)*(1-s)*(2*r+n+s+1);
        dhdr(2,1)=1/8*(1-n)*(1-s)*(2*r-n-s-1);
        dhdr(3,1)=1/8*(1+n)*(1-s)*(2*r+n-s-1);
        dhdr(4,1)=1/8*(1+n)*(1-s)*(2*r-n+s+1);
        dhdr(5,1)=1/8*(1-n)*(1+s)*(2*r+n-s+1);
        dhdr(6,1)=1/8*(1-n)*(1+s)*(2*r-n+s-1);
        dhdr(7,1)=1/8*(1+n)*(1+s)*(2*r+n+s-1);
        dhdr(8,1)=1/8*(1+n)*(1+s)*(2*r-n-s+1);
        %
        dhdr(9,1)=1/4*(-2*r)*(1-n)*(1-s);
        dhdr(11,1)=1/4*(-2*r)*(1+n)*(1-s);
        dhdr(13,1)=1/4*(-2*r)*(1-n)*(1+s);
        dhdr(15,1)=1/4*(-2*r)*(1+n)*(1+s);
        %
        dhdr(10,1)=1/4*(1)*(1-n^2)*(1-s);
        dhdr(12,1)=1/4*(-1)*(1-n^2)*(1-s);
        dhdr(14,1)=1/4*(1)*(1-n^2)*(1+s);
        dhdr(16,1)=1/4*(-1)*(1-n^2)*(1+s);
        %
        dhdr(17,1)=1/4*(-1)*(1-n)*(1-s^2);
        dhdr(18,1)=1/4*(1)*(1-n)*(1-s^2);
        dhdr(19,1)=1/4*(1)*(1+n)*(1-s^2);
        dhdr(20,1)=1/4*(-1)*(1+n)*(1-s^2);
        
        %Calculate the derivatives of the shape function w.r.t n
        dhdn(1,1)=1/8*(1-r)*(1-s)*(r+2*n+s+1);
        dhdn(2,1)=1/8*(1+r)*(1-s)*(-r+2*n+s+1);
        dhdn(3,1)=1/8*(1+r)*(1-s)*(r+2*n-s-1);
        dhdn(4,1)=1/8*(1-r)*(1-s)*(-r+2*n-s-1);
        dhdn(5,1)=1/8*(1-r)*(1+s)*(r+2*n-s+1);
        dhdn(6,1)=1/8*(1+r)*(1+s)*(-r+2*n-s+1);
        dhdn(7,1)=1/8*(1+r)*(1+s)*(r+2*n+s-1);
        dhdn(8,1)=1/8*(1-r)*(1+s)*(-r+2*n+s-1);
        %
        dhdn(9,1)=1/4*(1-r^2)*(-1)*(1-s);
        dhdn(11,1)=1/4*(1-r^2)*(1)*(1-s);
        dhdn(13,1)=1/4*(1-r^2)*(-1)*(1+s);
        dhdn(15,1)=1/4*(1-r^2)*(1)*(1+s);
        %
        dhdn(10,1)=1/4*(1+r)*(-2*n)*(1-s);
        dhdn(12,1)=1/4*(1-r)*(-2*n)*(1-s);
        dhdn(14,1)=1/4*(1+r)*(-2*n)*(1+s);
        dhdn(16,1)=1/4*(1-r)*(-2*n)*(1+s);
        %
        dhdn(17,1)=1/4*(1-r)*(-1)*(1-s^2);
        dhdn(18,1)=1/4*(1+r)*(-1)*(1-s^2);
        dhdn(19,1)=1/4*(1+r)*(1)*(1-s^2);
        dhdn(20,1)=1/4*(1-r)*(1)*(1-s^2);

        %Calculate the derivatives of the shape function w.r.t s
        dhds(1,1)=1/8*(1-r)*(1-n)*(r+n+2*s+1);
        dhds(2,1)=1/8*(1+r)*(1-n)*(-r+n+2*s+1);
        dhds(3,1)=1/8*(1+r)*(1+n)*(-r-n+2*s+1);
        dhds(4,1)=1/8*(1-r)*(1+n)*(r-n+2*s+1);
        dhds(5,1)=1/8*(1-r)*(1-n)*(-r-n+2*s-1);
        dhds(6,1)=1/8*(1+r)*(1-n)*(r-n+2*s-1);
        dhds(7,1)=1/8*(1+r)*(1+n)*(r+n+2*s-1);
        dhds(8,1)=1/8*(1-r)*(1+n)*(-r+n+2*s-1);
        %
        dhds(9,1)=1/4*(1-r^2)*(1-n)*(-1);
        dhds(11,1)=1/4*(1-r^2)*(1+n)*(-1);
        dhds(13,1)=1/4*(1-r^2)*(1-n)*(1);
        dhds(15,1)=1/4*(1-r^2)*(1+n)*(1);
        %
        dhds(10,1)=1/4*(1+r)*(1-n^2)*(-1);
        dhds(12,1)=1/4*(1-r)*(1-n^2)*(-1);
        dhds(14,1)=1/4*(1+r)*(1-n^2)*(1);
        dhds(16,1)=1/4*(1-r)*(1-n^2)*(1);
        %
        dhds(17,1)=1/4*(1-r)*(1-n)*(-2*s);
        dhds(18,1)=1/4*(1+r)*(1-n)*(-2*s);
        dhds(19,1)=1/4*(1+r)*(1+n)*(-2*s);
        dhds(20,1)=1/4*(1-r)*(1+n)*(-2*s);
    end

end