% Plot the Result
close all;
load FEA_output_data.mat coord lotogo nnod nDOFPN jj young poisson d nel dTemp coefExp;


%Plot the Deformation for the Load Case
%Defined if you want the undeform shape : 1 - Yes
%                                         0 - No
IncludeUndeform =1;

%Stress to Plot
stresstitle=['Sxx';'Syy';'Szz';'Sxy';'Syz';'Szx'];
% 1 - Sxx ; 2 - Syy ; 3 - Szz ; ....
isig=1;

%Amplification Factor for the Deformation Plots
AmplificationFactor=50;
AmpFactorDeformationStress=0;

%Define the 6 faces of the cube
%
%      c8---c15---c7
%     /|          /|
%   c16|        c14|
%   /  |        /  |
%  c5---c13---c6   |
%  |  c20      |  c19
%  |   |       |   |
%  |   |       |   |
% c17  |      c18  |
%  |   c4---c11|--c3
%  |  /        |  /
%  |c12        |c10
%  |/          |/
%  c1---c09---c2
%
faceN=[1,9,2,10,3,11,4,12;5,13,6,14,7,15,8,16;1,9,2,18,6,13,5,17;2,10,3,19,7,14,6,18;4,11,3,19,7,15,8,20;1,12,4,20,8,16,5,17];
faceNStress=[1,2,3,4;5,6,7,8;1,2,6,5;2,3,7,6;4,3,7,8;1,4,8,5];  % Only corner nodes

%Initizalization of the variables
x=zeros(nnod,1);
y=zeros(nnod,1);
z=zeros(nnod,1);
disp=zeros(nnod,nDOFPN);
dispV=zeros(nnod*nDOFPN,1);

%Deformation Plot
figure(1)
hold on;
for iPD=1:2
    
    % Color use to paint the Face of the element
    if (iPD==1)
        ColorFace='w'; 
    else
        ColorFace='g';
    end  
        
    if   (IncludeUndeform ==1 || iPD==2)
        
        if   (IncludeUndeform ==1 && iPD==2)
                alpha(0.3); % Plot the undeformed shape transparent
        end
        
        for iel=1:nel

            %Extract Element geometry
            for iloc=1:nnod,
                x(iloc,1)=coord(lotogo(iel,iloc),1);
            	y(iloc,1)=coord(lotogo(iel,iloc),2);
				z(iloc,1)=coord(lotogo(iel,iloc),3);
            end;

            %Extract Element Node Displacement.
            for iloc=1:nnod,
                inod=lotogo(iel,iloc);
                for idir=1:nDOFPN,
                    disp(iloc,idir)=0;
                    ieqnm=jj(inod,idir);
                    if (ieqnm~=0),
                        disp(iloc,idir)=disp(iloc,idir)+d(ieqnm);
                    end;
                end;
            end;
   
   
            %Amplification of the deformation
            AmpFactor=(iPD-1)*AmplificationFactor; 
           
            %The Element is plot
            for iface=1:6,
                faceNode = faceN(iface,:);
                fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),z(faceNode,1)+AmpFactor*disp(faceNode,3),y(faceNode,1)+AmpFactor*disp(faceNode,2),ColorFace);
            end
  
        end 
    end
end

hold off
grid;
axis([-50 50 -50 50 -35 35]);
set(gca,'YDir','rev');
view(45,35);
title(strcat('Deformed Shape','    Amplification Factor=',num2str(AmpFactor)));
xlabel('X');ylabel('Z');zlabel('Y');
print('-djpeg','-r600',strcat('Deformed_Shape_AmpFactor_',num2str(AmpFactor),'.jpeg'));

%--------------------- PLOT STRESSES ---------------------

% figure(2)
% hold on;
% MinStress=inf;
% MaxStress=-inf;

for isig=1:6;    % Stress Component to Plot
    
    figure(2)
    hold on;
    MinStress = +inf;
    MaxStress = -inf;
    
    for iel=1:nel
        
        %Extract Element geometry
        for iloc=1:nnod,
            x(iloc,1)=coord(lotogo(iel,iloc),1);
            y(iloc,1)=coord(lotogo(iel,iloc),2);
            z(iloc,1)=coord(lotogo(iel,iloc),3);
        end;
        
        %Extract Element Node Displacement.
        for iloc=1:nnod,
            inod=lotogo(iel,iloc);
            for idir=1:nDOFPN,
                disp(iloc,idir)=0;
                dispV((iloc-1)*3 + idir,1)=0.0;
                ieqnm=jj(inod,idir);
                if (ieqnm~=0),
                    disp(iloc,idir)=disp(iloc,idir)+d(ieqnm);
                    dispV((iloc-1)*3 + idir,1)=d(ieqnm);
                end;
            end;
        end;
        
        %Amplification of the deformation
        AmpFactor=AmpFactorDeformationStress;
        
        
        % Plot the stress of each face at the projection of integration
        % point in the face of the element
        for iface=1:6;
            
            faceNode = faceNStress(iface,:);
            
            % (2*2) Gauss Point Coordinates at each Face of the Element
            ag=1/sqrt(3); bg=-1/sqrt(3); cg=1; dg=-1;
            Face_G=[bg,bg,dg; ag,bg,dg; ag,ag,dg; bg,ag,dg;...
                    bg,bg,cg; ag,bg,cg; ag,ag,cg; bg,ag,cg;...
                    dg,bg,bg; dg,ag,bg; dg,ag,ag; dg,bg,ag;...
                    cg,bg,bg; cg,ag,bg; cg,ag,ag; cg,bg,ag;...
                    bg,dg,bg; bg,dg,ag; ag,dg,ag; ag,dg,bg;...
                    bg,cg,bg; bg,cg,ag; ag,cg,ag; ag,cg,bg];
            
            % Compute the stress at each projection of the integration point
            % in the Face using 2 Gauss Points (2*2)
            sig1=stress(young, poisson,x,y,z,dispV,Face_G(4*(iface-1)+1,1),Face_G(4*(iface-1)+1,2),Face_G(4*(iface-1)+1,3),dTemp,coefExp);
            sig2=stress(young, poisson,x,y,z,dispV,Face_G(4*(iface-1)+2,1),Face_G(4*(iface-1)+2,2),Face_G(4*(iface-1)+2,3),dTemp,coefExp);
            sig3=stress(young, poisson,x,y,z,dispV,Face_G(4*(iface-1)+3,1),Face_G(4*(iface-1)+3,2),Face_G(4*(iface-1)+3,3),dTemp,coefExp);
            sig4=stress(young, poisson,x,y,z,dispV,Face_G(4*(iface-1)+4,1),Face_G(4*(iface-1)+4,2),Face_G(4*(iface-1)+4,3),dTemp,coefExp);
            ColorFaceStress=[sig1(isig,1),sig2(isig,1),sig3(isig,1),sig4(isig,1)];
            if (MaxStress < max(ColorFaceStress))
                MaxStress=max(ColorFaceStress);
            end
            if (MinStress > min(ColorFaceStress))
                MinStress=min(ColorFaceStress);
            end
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),z(faceNode,1)+AmpFactor*disp(faceNode,3),y(faceNode,1)+AmpFactor*disp(faceNode,2),ColorFaceStress);
          
        end
        
    end ;
    
    hold off
    grid;
    axis([-50 50 -50 50 -35 35]);
    set(gca,'YDir','rev');
    view(45,35);
    title_Var={'Stress \sigma_x_x','Stress \sigma_y_y','Stress \sigma_z_z','Stress \tau_x_y','Stress \tau_y_z','Stress \tau_x_z'};
    title(title_Var(isig));
    %xlabel('x');ylabel('y');zlabel('z');
    axes('position',[.05  .05  .9  .01])
    pcolor([1:0.1:10;1:0.1:10]);
    set(gca,'XTickLabel',{MinStress:(MaxStress-MinStress)/8:MaxStress});
    set(gca,'YTickLabel',{''});
    print_Var={'Stress_Sxx.jpeg','Stress_Syy.jpeg','Stress_Szz.jpeg','Stress_TAUxy.jpeg','Stress_TAUyz.jpeg','Stress_TAUxz.jpeg'};
    print('-djpeg','-r600',char(print_Var(isig)));
    close all
    
end;

clear all
clc