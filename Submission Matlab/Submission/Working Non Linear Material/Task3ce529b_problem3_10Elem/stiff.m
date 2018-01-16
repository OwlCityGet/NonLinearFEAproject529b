function [akloc,fel,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel]=stiff(x,y,z,nNodes,nGP,FlagNLG,FlagNLM,disp,Ddisp,young,youngp,poisson,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel,erry,bet)
%****************************************************
%*                                                  *
%*   FORMS THE ELEMENT TANGENT STIFFNESS MATRIX     *
%*                                                  *
%****************************************************
%
% x,y,z       : vectors with the coordinate of each node of the element analized
% nNodes      : number of Nodes in the element analyzed
% nGP         : number of Gauss Point need to be used in the element for each direction
% FlagNLG     : Flag that indicate if you need to include Nonlinear Geometry (Total Lagrangian)[0 - No , 1 - Yes]
% FlagNLM     : Flag that indicate the  material to used for the state determination [ 0 - Linear Elastic Material ; 1 - Hyper Elastic Material; 2 - Von Mises Material]
% disp        : displacement at the nodes
% Ddisp       : the increment displacement at the last iteration
% young       : Young Modulus
% youngp      : Young Modulus after Yielding 
% poisson     : poisson constant
% tijoldel    : the variable that storage the vector with the 6 stresses at each gauss point for the element analyzed
% Mtijoldel   : the variable that storage the 3x3 stress matrix at each gauss point for the element analyzed
% Myscoldel   : the variable that storage the 3x3 stress matrix with the yield surface center at each gauss point for the element analyzed
% akpoldel    : the variable that storgare the Yield Stress at each gauss point for the element analyzed
% epAcumel    : the variable that storage the Acumulative or incremental Plastic Stretching at each gauss point for the element analyzed
% MepijAcumel : the variable that storage the Acumulative or incremental Plastic Stretching in each component at each gauss point for the element analyzed
% erry        : parameter for Von Mises Material
% bet         : Kinematic Hardenig : 0 Isotropic Hardening : 1
% akloc       : the stiffness matrix for the element analyzed ( Include the material and geometry stiffness matrix)
% fel         : the resistant force vector


    % ZERO ELEMENT STIFFNESS MATRIX AND FORCE VECTOR
    felR=zeros(nNodes*3,1);
    akloc=zeros(nNodes*3,nNodes*3);
    GM=zeros(nNodes,nNodes);
    tijelRec=zeros(6,(nGP^3));
    iGP=0;
    
    K=zeros(nNodes*3);

    for ii=1:20
        for jj=1:3
            Ubkl(ii,jj)=disp(ii*3-3+jj,1);
            dUbkl(ii,jj)=Ddisp(ii*3-3+jj,1);
        end
    end
    % Initialize Element Tangent Stiffness Matrix and Force Vector
    % We Loop on the number of Gaussian Point in Each Direction
    for i=1:nGP,
        [r,wr]=GaussPoint(nGP,i);
        for j=1:nGP,
            [n,wn]=GaussPoint(nGP,j);
            for k=1:nGP,
                [s,ws]=GaussPoint(nGP,k);
        
                %We calculate the number of the Gaussian Point 
                iGP=iGP+1;
                
                %Call the function that create the Shape func and their derivatives and it is evaluate at the gauss point 
                [shapeF,dhdr,dhdn,dhds]=CreateShapeFunc(r,n,s,nNodes);
        
                %Create the jacobian and its inverse
                [ajac]=CreateJacobian(dhdr,dhdn,dhds,x,y,z);
                [ajacinv,det,c]=jacinv(ajac);
                
                %Create the matrix B and C and H
                B=[ajacinv zeros(3,6);
                   zeros(3) ajacinv zeros(3);
                   zeros(3,6) ajacinv];
                H=[dhdr';dhdn';dhds'];
                F=ajacinv*H;
                for jj=1:20
                    C(1:3,3*jj-2:3*jj)=[H(:,jj),zeros(3,1),zeros(3,1)];
                    C(4:6,3*jj-2:3*jj)=[zeros(3,1),H(:,jj),zeros(3,1)];
                    C(7:9,3*jj-2:3*jj)=[zeros(3,1),zeros(3,1),H(:,jj)];
                end
        
                %Create the A and the derivatives of the displacements ub_k,l = alfa
                
                alfa=F*Ubkl;
                alfaDd=F*dUbkl;
                if FlagNLG==1
                    A=1*[1+alfa(1,1),0,0,alfa(1,2),0,0,alfa(1,3),0,0;
                        0,alfa(2,1),0,0,1+alfa(2,2),0,0,alfa(2,3),0;
                        0,0,alfa(3,1),0,0,alfa(3,2),0,0,1+alfa(3,3);
                        alfa(2,1),1+alfa(1,1),0,1+alfa(2,2),alfa(1,2),0,alfa(2,3),alfa(1,3),0;
                        0,alfa(3,1),alfa(2,1),0,alfa(3,2),1+alfa(2,2),0,1+alfa(3,3),alfa(2,3);
                        alfa(3,1),0,1+alfa(1,1),alfa(3,2),0,alfa(1,2),1+alfa(3,3),0,alfa(1,3)
                        ];
                else
                A=1*[1,0,0,0,0,0,0,0,0;
                    0,0,0,0,1,0,0,0,0;
                    0,0,0,0,0,0,0,0,1;
                    0,1,0,1,0,0,0,0,0;
                    0,0,0,0,0,1,0,1,0;
                    0,0,1,0,0,0,1,0,0
                    ];
                end
                
                % Perfom the State Determination for the Gauss Point Study   
                switch FlagNLM
                    case 0
                        
                        % It is perform the State determination of an Elastic Material
                        [Et,tijel,Mtijel]=StateDetElasticMaterial(young,poisson,alfa,FlagNLG);    
                        
                    case 1
               
                        % It is perform the State determination of an Hyper-Elastic Material
                        
                    otherwise
                    
                        % It is perform the State determination of an Von Mises Material
                        % Extract the parameter to do the state determination for Von Mises at the gauss point analyzed
%                         iGP;
                        [Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum]=CreateParametersVSDMMat(iGP,alfaDd,FlagNLG,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel);
                    
                        [Et,mstat,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum]=StateDetVonMisesMat(young,youngp,poisson,Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum,bet,erry);
                        
                        % Update the parameter after it is done the state determination for Von Mises at the gauss point analyzed
                        [tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel]=UpdateParametersVSDMMat(iGP,tijold,Mtijold,akpold,Myscold,epAcum,MepijAcum,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel);
                
                        Mtijel=Mtijold;
                        tijel=tijold;
                end
                               
                % Perform the numerical integration for the gauss point study
                D=A*B*C;
                K=K+D'*Et*D*det*wr*wn*ws;
        
                % Calculate the Geometrix Matrix
                if FlagNLG==1
                GM=GM+F'*Mtijel*F*det*wn*wr*ws;
                end
                
                % Calculate the felR
                felR=felR+D'*tijel*det*wr*wn*ws;

                % We Storage the tij for the Gauss Point
                tijelRec(:,iGP)=tijel;
                
            end;
        end;
    end;
        if FlagNLG==1
            G=[GM,zeros(nNodes),zeros(nNodes);
                zeros(nNodes),GM,zeros(nNodes);
                zeros(nNodes),zeros(nNodes),GM];
            T=zeros(nNodes);
            vx=1:20;
            vy=21:40;
            vz=41:60;
            hx=linspace(1,58,nNodes);
            hy=linspace(2,59,nNodes);
            hz=linspace(3,60,nNodes);
            for ii=1:nNodes
                T(vx(ii),hx(ii))=1;
                T(vy(ii),hy(ii))=1;
                T(vz(ii),hz(ii))=1;
            end
            G=T'*G*T;
            akloc=K+G;
        else
            akloc=K;
        end


    % Residual force for the element
    fel= -felR';


    tijoldel=tijelRec;
    
end