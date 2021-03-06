function [MEt,mstat,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum]=StateDetVonMisesMat(young,youngp,poisson,Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum,bet,erry)
%
%
% young     : Young Modulus
% youngp    : Young Modulus after Yielding 
% poisson   : poisson constant
% Vdet      : Vector that contains the incremental total strain 
% tijold    : the variable that storage the vector with the 6 stresses for the gauss point analyzed
% Mtijold   : the variable that storage the 3x3 stress matrix for the gauss point analyzed
% Myscold   : the variable that storage the 3x3 stress matrix with the yield surface center for the gauss point analyzed
% akpold    : the variable that storgare the Yield Stress for the gauss point analyzed
% epAcum    : the variable that storage the Acumulative or incremental Plastic Stretching for the gauss point analyzed
% MepijAcum : the variable that storage the Acumulative or incremental Plastic Stretching in each component for the gauss point analyzed
% erry      : parameter for Von Mises Material
% bet       : Kinematic Hardenig : 0 Isotropic Hardening : 1
% Mtij      : the variable that storage the new 3x3 stress matrix for the gauss point analyzed
% Myscnew   : the variable that storage the new 3x3 stress matrix with the yield surface center for the gauss point analyzed
% akpnew    : the variable that storgare the new Yield Stress for the gauss point analyzed
% MEt       : Material Matrix 6x6
% mstat     : parameter that returns if total stress value is inside or outside yield surface


 %ihard=1; % for isotropic
 mstat=1 ;
 %erry=0.001 ; % tolerance in yield function
 erry=0.001 ; % tolerance in yield function
 
  %if (ihard==1) 
    h=young*youngp/(young-youngp) ;
  %end
   
sigBar=sqrt(2/3)*akpold;
%   'radius'
%bkp=akpold/(3.0^0.5);
%yfrad2=bkp^2 ;
bkp=sqrt(0.5)*sigBar;
yfrad2=bkp^2;
  p=poisson;
  Ed=[1-p p p 0 0 0;
        p 1-p p 0 0 0;
        p p 1-p 0 0 0;
        0 0 0 (1-2*p)/2 0 0;
        0 0 0 0 (1-2*p)/2 0;
        0 0 0 0 0 (1-2*p)/2];

  E=(Ed*young/((1+p)*(1-2*p)));
  MEt=E;
  dsig=MEt*Vdet;
  tijtrl=tijold+dsig ;
  Mtijold=Vec_Mat(tijtrl);
  tsigm=(tijtrl(1,1)+tijtrl(2,1)+tijtrl(3,1))/3.0 ;
  dvsig=tijtrl-tsigm*[1 1 1 0 0 0]' ; % deviatoric stress vector
  Mdvsig=Vec_Mat(dvsig);% deviatoric stress matrix
  t=Mdvsig-Myscold ;
  %yldf=0.5*sum(sum(t.^2))-yfrad2;
  yldf=0.5*EucNorm(t)-yfrad2;
  errry=-erry*yfrad2 ;
  
  if (yldf>errry) 
    mstat=2;
  end
  errry=-errry ;

  if (yldf<=errry)
      'elastic domain';
      tijold=tijtrl;
      MEt=E;
      Mtijold=Vec_Mat(tijold);
 
  end 
  
  if (yldf>errry) 
      'plastic domain'
      Hbar=2*h/3;
      mu=young/(2*(1+p));
      depBar=sqrt(2/3)*((sqrt(2*yldf+sigBar^2)-sigBar)/(2*mu+Hbar));
      epAcum=epAcum+depBar;
      %Mdvsig=Vec_Mat(dvsig);
      dep=sqrt(1.5)*depBar*(Mdvsig-Myscold)/EucNorm(Mdvsig-Myscold);

      %MepijAcum=MepijAcum+dep;
      Mdvsig=Mdvsig-sqrt(6)*mu*depBar*(Mdvsig-Myscold)/sqrt(EucNorm(Mdvsig-Myscold));
      %if (ihard==1)
      Myscold=Myscold+Hbar*(1-bet)*dep;
      if bet==1
          akpold=sqrt(1.5*EucNorm(Mdvsig-Myscold));
      else 
          akpold=akpold;
      end

      %end


      %if (ihard==1)
        be=1.5*(1/akpold)^2*(1+(2/3)*((young*youngp)/(young-youngp))*((1+p)/young))^-1;
            a=(1-p)/(1-2*p);
            b=(p)/(1-2*p);
            S=Mdvsig-Myscold;
            
            cep(1,1)= a-be*S(1,1)*S(1,1) ;
            cep(1,2)= b-be*S(1,1)*S(2,2) ;
            cep(1,3)= b-be*S(1,1)*S(3,3) ;
            cep(1,4)= -be*S(1,1)*S(1,2) ;
            cep(1,5)= -be*S(1,1)*S(2,3) ;
            cep(1,6)= -be*S(1,1)*S(1,3) ;
            
            cep(2,1)= cep(1,2);
            cep(2,2)= a-be*S(2,2)*S(2,2);
            cep(2,3)= b-be*S(2,2)*S(3,3) ;
            cep(2,4)= -be*S(2,2)*S(1,2) ;
            cep(2,5)= -be*S(2,2)*S(2,3) ;
            cep(2,6)= -be*S(2,2)*S(1,3) ;
            
            cep(3,1)= cep(1,3);
            cep(3,2)= cep(2,3);
            cep(3,3)= a-be*S(3,3)*S(3,3) ;
            cep(3,4)= -be*S(3,3)*S(1,2) ;
            cep(3,5)= -be*S(3,3)*S(2,3) ;
            cep(3,6)= -be*S(3,3)*S(1,3) ;
            
            cep(4,1)= cep(1,4);
            cep(4,2)= cep(2,4);
            cep(4,3)= cep(3,4);
            cep(4,4)= 0.5-be*S(1,2)*S(1,2) ;
            cep(4,5)= a-be*S(1,2)*S(2,3) ;
            cep(4,6)= a-be*S(1,2)*S(1,3) ;
            
            cep(5,1)= cep(1,5);
            cep(5,2)= cep(2,5);
            cep(5,3)= cep(3,5);
            cep(5,4)= cep(4,5);
            cep(5,5)= 0.5-be*S(2,3)*S(2,3) ;
            cep(5,6)= -be*S(2,3)*S(1,3);

            cep(6,1)= cep(1,6);
            cep(6,2)= cep(2,6);
            cep(6,3)= cep(3,6);  
            cep(6,4)= cep(4,6);
            cep(6,5)= cep(5,6);
            cep(6,6)= 0.5-be*S(1,3)*S(1,3) ;


        cep=(young/(1+p))*cep;
        MEt=cep;
        
      %end

      
      tijold=tijold+MEt*Vdet;
      Mtijold=Vec_Mat(tijold);
  end
    
    
end