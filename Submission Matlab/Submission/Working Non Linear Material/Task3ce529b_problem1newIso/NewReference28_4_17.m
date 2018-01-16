function [MEt,mstat,tijold,Mtij,Myscnew,akpnew,epAcum,MepijAcum]=StateDetVonMisesMat(young,youngp,poisson,Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum,bet,erry)
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


 ihard=1; % for isotropic
 mstat=1 ;
 erry=0.001 ; % tolerance in yield function
  if (ihard==1) 
  h=young*youngp/(young-youngp) ;
  end
  bkp=akpold/(3.0^0.5) ;
  yfrad2=bkp^2 ;
  p=poisson;
  Ed=[1-p p p 0 0 0;
        p 1-p p 0 0 0;
        p p 1-p 0 0 0;
        0 0 0 (1-2*p)/2 0 0;
        0 0 0 0 (1-2*p)/2 0;
        0 0 0 0 0 (1-2*p)/2];

  MEt=(Ed*young/((1+p)*(1-2*p)));
  dsig=MEt*Vdet;
  tijtrl=tijold+dsig ;
  tsigm=(tijtrl(1,1)+tijtrl(2,1)+tijtrl(3,1))/3.0 ;
  dvsig=tijtrl-tsigm*[1 1 1 0 0 0]' ;
  Mdvsig=Vec_Mat(dvsig);
  t=Vec_Mat(dvsig)-Myscold ;
  yldf=0.5*(EucNorm(t))^2-yfrad2 ;
  errry=-erry*yfrad2 ;
  if (yldf>errry) 
    mstat=2;
  end
  errry=-errry ;

  if (yldf<=errry) 
      Mtij=Vec_Mat(tijtrl);
      Myscnew=Myscold;
      akpnew=akpold;
  end
  if (yldf>errry) 
      f=0.5*(EucNorm(t))^2-0.5*yfrad2;
      sigBar=sqrt(2*yfrad2);
      Hbar=2*h/3;
      mu=young/(2*(1+p));
      depBar=sqrt(2/3)*((sqrt(2*f+sigBar^2)-sigBar)/(2*mu+Hbar));
      %epAcum=sqrt(2/3)*((sqrt(2*f+sigBar^2)-sigBar)/(2*mu+Hbar));
      Mdvsig=Vec_Mat(tijtrl);
      dep=sqrt(1.5)*depBar*(Mdvsig-Myscold)/EucNorm(Mdvsig-Myscold);
      epAcum=epAcum+depBar; 
      %epAcum=epAcum+depBar; 
      %dep=sqrt(1.5)*epAcum*(Mdvsig-Myscold)/EucNorm(Mdvsig-Myscold);
      MepijAcum=MepijAcum+(dep);
      Mdvsig=Mdvsig-2*mu*dep;
      %Mtij=Mtijtrl-mu*sqrt(6)*depBar*(Mtijtrl-Myscold)/EucNorm(Mtijtrl-Myscold) +(lamda+(2/3)*mu)*trace(Mept)*eye(3);
      %Myscnew=Myscold+sqrt(3/2)*(1.0-bet)*h*depBar*(Mtijtrl-Myscold)/EucNorm(Mtijtrl-Myscold) ;
      Myscnew=Myscold+Hbar*(1-bet)*dep;%depBar*(Mtij-Myscold)/EucNorm(Mtij-Myscold);
      %akpnew= sqrt(2/3)*sqrt(EucNorm(Mtij-Myscnew));
      Mtij=Mdvsig+tsigm;
      
      
      if (bet==1.0)
        akpnew=abs(sqrt(1.5)*EucNorm(Mdvsig-Myscnew)) ;
      else
          akpnew=akpold;
      end
      if (ihard==1)
        be=1.5*(1/akpnew)*(1+(2/3)*((young*youngp)/(young-youngp))*((1+p)/young))^-1;
        a11=(1-p)/(1-2*p);
        a22=(p)/(1-2*p);
        Mdvsig=Vec_Mat(dvsig);
        cep(1,1)= a11-be*Mdvsig(1,1)*Mdvsig(1,1) ;
        cep(1,2)= a22-be*Mdvsig(1,1)*Mdvsig(2,2) ;
        cep(1,3)= a22-be*Mdvsig(1,1)*Mdvsig(3,3) ;
        cep(1,4)= -be*Mdvsig(1,1)*Mdvsig(1,2) ;
        cep(1,5)= -be*Mdvsig(1,1)*Mdvsig(2,3) ;
        cep(1,6)= -be*Mdvsig(1,1)*Mdvsig(1,3) ;
        cep(2,1)=cep(1,2);
        cep(3,1)=cep(1,3);
        cep(4,1)=cep(1,4);
        cep(5,1)=cep(1,5);
        cep(6,1)=cep(1,6);

        cep(2,2)= a11-be*Mdvsig(2,2)*Mdvsig(2,2);
        cep(2,3)= a22-be*Mdvsig(2,2)*Mdvsig(3,3) ;
        cep(2,4)= -be*Mdvsig(2,2)*Mdvsig(1,2) ;
        cep(2,5)= -be*Mdvsig(2,2)*Mdvsig(2,3) ;
        cep(2,6)= -be*Mdvsig(2,2)*Mdvsig(1,3) ;
        cep(3,2)=cep(2,3);
        cep(4,2)=cep(2,4);
        cep(5,2)=cep(2,5);
        cep(6,2)=cep(2,6);

        cep(3,3)= a11-be*Mdvsig(3,3)*Mdvsig(3,3) ;
        cep(3,4)= -be*Mdvsig(3,3)*Mdvsig(1,2) ;
        cep(3,5)= -be*Mdvsig(3,3)*Mdvsig(2,3) ;
        cep(3,6)= -be*Mdvsig(3,3)*Mdvsig(1,3) ;
        cep(4,3)=cep(3,4);
        cep(5,3)=cep(3,5);
        cep(6,3)=cep(3,6);                  

        cep(4,4)= 0.5-be*Mdvsig(1,2)*Mdvsig(1,2) ;
        cep(4,5)= a11-be*Mdvsig(1,2)*Mdvsig(2,3) ;
        cep(4,6)= a11-be*Mdvsig(1,2)*Mdvsig(1,3) ;
        cep(5,4)=cep(4,5);
        cep(5,6)=cep(6,5);

        cep(5,5)= 0.5-be*Mdvsig(2,3)*Mdvsig(2,3) ;
        cep(5,6)= -be*Mdvsig(2,3)*Mdvsig(1,3) ;
        cep(2,1)=cep(1,2);

        cep(6,6)= 0.5-be*Mdvsig(1,3)*Mdvsig(1,3) ;

        cep=(young/1+p)*cep;
        MEt=cep;
      end
  end
  tijold=tijold+MEt*Vdet;
  Mtij=Vec_Mat(tijold);
  
end