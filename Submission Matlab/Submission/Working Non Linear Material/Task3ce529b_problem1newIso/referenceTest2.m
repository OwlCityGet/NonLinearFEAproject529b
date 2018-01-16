

 
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
        h=young*youngp/(young-youngp) ;
      end

%
%     AKAP IS THE YIELD STRESS FROM A UNIAXIAL TENSION TEST.
      akp=akpold ;
%
%     ysc IS THE YIELD STRESS FROM A UNIAXIAL TENSION TEST.
      ysc=Myscold ;
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
              cep=MEt ;
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
                  con=h+young ;
                  dep=(dtrial-dysurf)/con ;
                  epAcum=epold+dep ;
            %
            %     UPDATE THE AXIAL STRESS VALUES AND STORE IN AXIAL
            %     STRESS STATE STORAGE AREA. RETURN TRIAL STRESS TO
            %     YIELD SURFACE.
            %     EQ. 43 BAR IN LECTURE 9 NOTES
                  atsig=abs(tsgtrl) ;
                  tsg=tsgtrl-MEt*dep*tsgtrl/atsig ;
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
                    be=1.5*(1/akp)*(1+(2/3)*(young*youngp)/(young-youngp)*((1+p)/young))^-1;
                    a11=(1-p)/(1-2*p);
                    a22=(p)/(1-2*p);
                    
                    cep(1,1)= a11-be*dvsig(1,1)*dvsig(1,1) ;
                    cep(1,2)= a22-be*dvsig(1,1)*dvsig(2,2) ;
                    cep(1,3)= a22-be*dvsig(1,1)*dvsig(3,3) ;
                    cep(1,4)= -be*dvsig(1,1)*dvsig(1,2) ;
                    cep(1,5)= -be*dvsig(1,1)*dvsig(2,3) ;
                    cep(1,6)= -be*dvsig(1,1)*dvsig(1,3) ;
                    cep(2,1)=cep(1,2);
                    cep(3,1)=cep(1,3);
                    cep(4,1)=cep(1,4);
                    cep(5,1)=cep(1,5);
                    cep(6,1)=cep(1,6);
                    
                    cep(2,2)= a11-be*dvsig(2,2)*dvsig(2,2);
                    cep(2,3)= a22-be*dvsig(2,2)*dvsig(3,3) ;
                    cep(2,4)= -be*dvsig(2,2)*dvsig(1,2) ;
                    cep(2,5)= -be*dvsig(2,2)*dvsig(2,3) ;
                    cep(2,6)= -be*dvsig(2,2)*dvsig(1,3) ;
                    cep(3,2)=cep(2,3);
                    cep(4,2)=cep(2,4);
                    cep(5,2)=cep(2,5);
                    cep(6,2)=cep(2,6);
                    
                    cep(3,3)= a11-be*dvsig(3,3)*dvsig(3,3) ;
                    cep(3,4)= -be*dvsig(3,3)*dvsig(1,2) ;
                    cep(3,5)= -be*dvsig(3,3)*dvsig(2,3) ;
                    cep(3,6)= -be*dvsig(3,3)*dvsig(1,3) ;
                    cep(4,3)=cep(3,4);
                    cep(5,3)=cep(3,5);
                    cep(6,3)=cep(3,6);                  
                                        
                    cep(4,4)= 0.5-be*dvsig(1,2)*dvsig(1,2) ;
                    cep(4,5)= a11-be*dvsig(1,2)*dvsig(2,3) ;
                    cep(4,6)= a11-be*dvsig(1,2)*dvsig(1,3) ;
                    cep(5,4)=cep(4,5);
                    cep(5,6)=cep(6,5);
                    
                    cep(5,5)= 0.5-be*dvsig(2,3)*dvsig(2,3) ;
                    cep(5,6)= -be*dvsig(2,3)*dvsig(1,3) ;
                    cep(2,1)=cep(1,2);
                    
                    cep(6,6)= 0.5-be*dvsig(1,3)*dvsig(1,3) ;
                  
                    cep=(young/1+p)*cep;
                  end

      end
%
%     SAVE THE OLD VALUES.
      eppold=eppnew ;
      
      tsgold=tsg  ;
      yscold=ysc ;
      akpold=akp ;
      
      epold=ep ;
