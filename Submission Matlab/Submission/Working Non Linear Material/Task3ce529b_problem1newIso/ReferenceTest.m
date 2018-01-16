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


    
    gama33= 0.5*(alfa'+alfa + alfa'*alfa);
    gama=[gama33(1,1) gama33(2,2) gama33(3,3) 2*gama33(1,2)  2*gama33(1,3) 2*gama33(2,3)]';
    
    tijel=MEt*gama;
    
    Mtijel=[tijel(1,1) tijel(4,1) tijel(5,1);
            tijel(4,1) tijel(2,1) tijel(6,1);
            tijel(5,1) tijel(6,1) tijel(3,1)];

%       global iunit
%       global e et bet eppold tsgold ysc yscold akpold mstat
%       global istart istep isubin jter eppnew depp cep
%       global fid ihard epult epold
 
%
%     NUMBER OF STRESS COMPONENTS (1-D PROBLEM).
      ncomp=1 ;
      erry=0.001 ;
%
%     DEFINE THE MATERIAL CONSTANT
      eee=young ;
      MEt=zeros(6,6);
      p=poisson;
      Ed=[1-p p p 0 0 0;
            p 1-p p 0 0 0;
            p p 1-p 0 0 0;
            0 0 0 (1-2*p)/2 0 0;
            0 0 0 0 (1-2*p)/2 0;
            0 0 0 0 0 (1-2*p)/2];

      MEt=(Ed*young/((1+p)*(1-2*p)));
%
%     DEFINE THE PLASTIC MODULUS.
      if (ihard==1) 
%     DEFINE LINEAR HARDENING MODULUS. 
        h=eee*et/(eee-et) ;
      end

%
%     AKAP IS THE YIELD STRESS FROM A UNIAXIAL TENSION TEST.
      akp=akpold ;
%
%     ysc IS THE YIELD STRESS FROM A UNIAXIAL TENSION TEST.
      ysc=yscold ;
%
%     THE STATEMENTS EXECUTED ON THE FIRST ENTRY TO THIS ROUTINE.
      if (istart==0) 
    %
    %     SET THE MATERIAL STATUS FLAG TO INITIAL ELASTIC VALUE.
          mstat=1 ;
    %
    %     SET THE AXIAL STRAIN AND STRESS FOR THE REFERENCE STATE TO
    %     ZERO INITIALLY.
          tsgold=0.0 ;
          eppold=0.0 ;
          yscold=0.0 ;
          akpold=akp ;

    %
    %     DEFINE INITIAL YIELD SURFACE CENTER.
          ysc=0.0 ;
    %
          istart=1 ;
      end
%
%     AKAP IS THE YIELD STRESS FROM A SIMPLE TENSION TEST.
%     BKAP IS THE KAPPA TERM IN THE VON MISES YIELD CRITERIA.? ?13
      bkp=akp/(3.0^0.5) ;
%
%     YFRAD2 IS THE YIELD FUNCTION SQUARED.
      yfrad2=bkp^2 ;
%
%     COMPUTE AXIAL TRIAL STRESS INCREMENT ASSUMING
%     ELASTIC BEHAVIOR. equation 18 bar
      dsig=MEt*Vdet ;
%
%     COMPUTE TOTAL AXIAL STRESS ASSUMING ELASTIC MATERIAL(TRIAL STRESS).
      tsgtrl=tijold+dsig ;
      Mt=[tsgtrl(1,1) tsgtrl(4,1) tsgtrl(5,1);
            tsgtrl(4,1) tsgtrl(2,1) tsgtrl(6,1);
            tsgtrl(5,1) tsgtrl(6,1) tsgtrl(3,1)];
%
%     FOR THE 1-D STRESS APPLICATIONS, COMPUTE HYDROSTATIC STRESS.
      tsigm=ttrace(Mt)/3 ;
%
%     COMPUTE AXIAL DEVIATORIC TRIAL STRESS.
      dvsig=Mt-tsigm*eye(3) ;
%
%     DEFINE DIFF. BET. TRIAL DEVIATORIC AXIAL STRESS AND
%     YIELD SURFACE CENTER STRESS.
      t=dvsig-Myscold ;
%
%     DEFINE YIELD FUNCTION VALUE.
%     VON MISES YIELD FUNCTION.
%     NOTE THAT THIS YIELD FUNCTION IS DEFINED IN TERMS OF DEV. STRESS.
%     EQ. 5 BAR IN LECTURE 9 NOTES
      yldf=(3.0/4.0)*(t*t)-yfrad2 ;
%

%
%     CHECK TO SEE IF TOTAL STRESS VALUE IS INSIDE OR OUTSIDE YIELD
%     SURFACE.
      mstat=1 ;
%
%     SPECIAL PROCEDURE TO CODE STATE FOR PRINTOUT AS PLASTIC
%     EVEN WHEN SMALL ARTIFICIAL NUMERICAL UNLOADING MAY HAVE
%     OCCURRED. 
      errry=-erry*yfrad2 ;
      if (yldf>errry) 
        mstat=2 ;
      end
      errry=-errry ;
%
%     IF STRESS POINT IS ONLY AN EPSILON ABOVE THE YIELD SURFACE,
%     CONTINUE TO TREAT IT AS ELASTIC.
      if (yldf<=errry) 
        %
        %     THE STRESS POINT LIES INSIDE OR ON THE YIELD SURFACE.
        %     THE ELASTIC CASE.
        %
        %     DEFINE CURRENT TOTAL STRESS AS OLD STRESS FOR NEXT STEP
        %     WITH ELASTIC STRESS INCREMENT.
              tsg=tsgtrl ;
        %
        %     DEFINE AXIAL ELASTIC-PLASTIC MATERIAL MATRIX AS ELASTIC MODULUS.
        %     THIS IS FOR USE IN FORMING INCREMENTAL STIFF. MATRIX. THIS IS
        %     [CEP].
              cep=eee ;
              ep=epold ;
        %
      end

      if (yldf>errry) 
            %
            %     THE TENTATIVE STRESS POINT LIES OUTSIDE THE YIELD SURFACE - THERE
            %     IS SOME PLASTIC STRAIN.
            %
            %     DEFINE DIST. FROM CENTER OF YIELD SURFACE TO TRIAL STRESS POINT.
            %     EQ. 35 BAR IN LECTURE 9 NOTES
                  dtrial=3.*(yldf+yfrad2) ;
                  dtrial=sqrt(dtrial) ;
            %
            %     DEFINE DISTANCE BETWEEN CENTER OF YIELD SURFACE AND YIELD SURFACE.
            %     EQ. 36 BAR IN LECTURE 9 NOTES
                  dysurf=3.*yfrad2 ;
                  dysurf=sqrt(dysurf) ;
            %
            %     DEFINE INCREMENTAL PLASTIC STRETCHING INTEGRAL.
            %     EQ. 38 BAR IN LECTURE 9 NOTES
            % accumelate the strain here
                  con=h+2 Mu ;
                  dep=(dtrial-dysurf)/con ;
                  ep=epold+dep ;
            %
            %     UPDATE THE AXIAL STRESS VALUES AND STORE IN AXIAL
            %     STRESS STATE STORAGE AREA. RETURN TRIAL STRESS TO
            %     YIELD SURFACE.
            %     EQ. 43 BAR IN LECTURE 9 NOTES
                  atsig=abs(tsgtrl) ;
                  tsg=tsgtrl-eee*dep*tsgtrl/atsig ;
            %
            %     UPDATE THE YIELD SURFACE CENTER.
            %     EQ. 44 BAR IN LECTURE 9 NOTES
                  sqrt23=2./3. ;
                  sqrt23=sqrt(sqrt23) ;
                  ysc=yscold+sqrt23*(1.0-bet)*h*dep*tsgtrl/atsig ;
            %
            %     UPDATE THE AXIAL YIELD SURFACE RADIUS-ACTUALLY THE EFFECTIVE
            %     TENSION YIELD STRESS.
                  akp=akpold+bet*h*dep ;
            %
            %     ANOTHER EQUIVALENT WAY WHEN BET EQUAL 1.,
            %     TO INSURE THAT AT NEXT STEP YIELD COND. IS EXACTLY SAT.
            %     THUS AVOIDING THE REAL UNLOADING PROBLEM.-FORCING THE ALGORITM
            %     AT THE START OF THE NEXT LOAD STEP TO USE THE ELASTIC MODULUS E.
            % update sigmabar dev-ysold
                  if (bet==1.0)
                    akp=abs(tsg) ;
                  end
            %
            %     DEFINE AXIAL ELASTIC-PLASTIC MATERIAL MATRIX.
            %     THIS IS FOR USE IN FORMING INCREMENTAL STIFF. MATRIX.
            %     THIS IS [CEP].
                  if (ihard==1)
                    a11=(1-p)/(1-2*p);
                    a22=(p)/(1-2*p);
                    
                    cep= (young/1+p)*[a11 a22 a22 ] ;
                  end

      end
%
%     SAVE THE OLD VALUES.
      eppold=eppnew ;
      
      tsgold=tsg  ;
      yscold=ysc ;
      akpold=akp ;
      
      epold=ep ;



end