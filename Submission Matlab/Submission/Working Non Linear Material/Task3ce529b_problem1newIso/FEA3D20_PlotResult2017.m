% Plot the Result
close all;
load FEA_output_data.mat coord lotogo jj nel nNodes d dRecord fRecord tijRecord MtijRecord MyscRecord akpRecord epAcumRecord MepijAcumRecord;

%global Prob

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
%Note: Input parameters below are as follows:

% IncludeUndeform to include undeformed structure
% isig to identify stress component to plot
% iIncr to identify load increment to print
% Colorface to identify face color in def structure plot
% AmpFactor to scale up displacements to visible
% View to set view direction
% Axis to define size of box containing plot
% Title to define plot title
% Program set to plot stress in tijRecord
% To plot plastic strains, switch to MepijAcumRecord or epAccumRecord 
% 

faceN=[1,9,2,10,3,11,4,12;5,13,6,14,7,15,8,16;1,9,2,18,6,13,5,17;2,10,3,19,7,14,6,18;4,11,3,19,7,15,8,20;1,12,4,20,8,16,5,17];
stresstitle=['Sxx';'Syy';'Szz';'Sxy';'Syz';'Szx'];

%Plot the Deformation for the Load Case
%Defined if you want the undeform shape : 1 - Yes
%                                         0 - No
IncludeUndeform =1;

%Stress to Plot
isig=1;

%Incremment to Print
%iIncr=size(dRecord,1);
iIncr=20;
d=dRecord(iIncr,:);

x=zeros(nNodes,1);
y=zeros(nNodes,1);
z=zeros(nNodes,1);
disp=zeros(nNodes,3);

figure
hold on;
for iPD=1:2
    
    % Color use to paint the Faces of the element
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
            for iloc=1:nNodes,
                x(iloc,1)=coord(lotogo(iel,iloc),1);
                y(iloc,1)=coord(lotogo(iel,iloc),2);
                z(iloc,1)=coord(lotogo(iel,iloc),3);
            end;
            
            %Extract Element Node Displacement.
            for iloc=1:nNodes,
                inod=lotogo(iel,iloc);
                for idir=1:3,
                    disp(iloc,idir)=0;
                    ieqnm=jj(inod,idir);
                    if (ieqnm~=0)
                        disp(iloc,idir)=disp(iloc,idir)+d(ieqnm);
                    end
                end
            end
            
            %Amplification of the deformation
            AmpFactor= (iPD-1)*5;          

            %Each face of the each cube is plot
            faceNode = faceN(1,:);            
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
            faceNode = faceN(2,:);            
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
            faceNode = faceN(3,:);
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
            faceNode = faceN(4,:);
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
            faceNode = faceN(5,:);
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
            faceNode = faceN(6,:);
            fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFace);
        end
    end
end

hold off
grid
% axis([-50 50 -10 100 -200 300])
%axis([-50 50 0 100 0 100])
axis([-1 5 -0.2 0.2 -0.2 0.2])
view(20,42)
view(80,20)
title('Deformed Shape')
xlabel('x'),ylabel('y'),zlabel('z'),

figure
hold on
MinStress=1000000000000000000000000000;
MaxStress=-1000000000000000000000000000;
colormap jet
for iel=1:nel
    
     %Extract Element geometry
     for iloc=1:20
         x(iloc,1)=coord(lotogo(iel,iloc),1);
         y(iloc,1)=coord(lotogo(iel,iloc),2);
         z(iloc,1)=coord(lotogo(iel,iloc),3);
     end
     
     %Extract Element Node Displacement.
     for iloc=1:20
         inod=lotogo(iel,iloc);
         for idir=1:3
             disp(iloc,idir)=0;
             ieqnm=jj(inod,idir);
             if (ieqnm~=0)
                 disp(iloc,idir)=disp(iloc,idir)+d(ieqnm);
             end
         end
     end
     
     %Amplification of the deformation
     AmpFactor=0;
    
     %Plot the stress of each face at the proyection of integration point in

     
     
     
     
     
     %in the face of the element
     faceNode = faceN(1,:);
     sig1=tijRecord(iIncr,iel,isig,1);
     sig2=tijRecord(iIncr,iel,isig,10);
     sig3=tijRecord(iIncr,iel,isig,19);
     sig4=tijRecord(iIncr,iel,isig,22);
     sig5=tijRecord(iIncr,iel,isig,25);
     sig6=tijRecord(iIncr,iel,isig,16);
     sig7=tijRecord(iIncr,iel,isig,7);
     sig8=tijRecord(iIncr,iel,isig,4);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
     faceNode = faceN(2,:);
     sig1=tijRecord(iIncr,iel,isig,3);
     sig2=tijRecord(iIncr,iel,isig,12);
     sig3=tijRecord(iIncr,iel,isig,21);
     sig4=tijRecord(iIncr,iel,isig,24);
     sig5=tijRecord(iIncr,iel,isig,27);
     sig6=tijRecord(iIncr,iel,isig,18);
     sig7=tijRecord(iIncr,iel,isig,9);
     sig8=tijRecord(iIncr,iel,isig,6);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
     faceNode = faceN(3,:);
     sig1=tijRecord(iIncr,iel,isig,1);
     sig2=tijRecord(iIncr,iel,isig,10);
     sig3=tijRecord(iIncr,iel,isig,19);
     sig4=tijRecord(iIncr,iel,isig,20);
     sig5=tijRecord(iIncr,iel,isig,21);
     sig6=tijRecord(iIncr,iel,isig,12);
     sig7=tijRecord(iIncr,iel,isig,3);
     sig8=tijRecord(iIncr,iel,isig,2);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
     faceNode = faceN(4,:);
     sig1=tijRecord(iIncr,iel,isig,19);
     sig2=tijRecord(iIncr,iel,isig,22);
     sig3=tijRecord(iIncr,iel,isig,25);
     sig4=tijRecord(iIncr,iel,isig,26);
     sig5=tijRecord(iIncr,iel,isig,27);
     sig6=tijRecord(iIncr,iel,isig,24);
     sig7=tijRecord(iIncr,iel,isig,21);
     sig8=tijRecord(iIncr,iel,isig,20);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
     faceNode = faceN(5,:);
     sig1=tijRecord(iIncr,iel,isig,7);
     sig2=tijRecord(iIncr,iel,isig,16);
     sig3=tijRecord(iIncr,iel,isig,25);
     sig4=tijRecord(iIncr,iel,isig,26);
     sig5=tijRecord(iIncr,iel,isig,27);
     sig6=tijRecord(iIncr,iel,isig,18);
     sig7=tijRecord(iIncr,iel,isig,9);
     sig8=tijRecord(iIncr,iel,isig,8);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
     faceNode = faceN(6,:);
     sig1=tijRecord(iIncr,iel,isig,1);
     sig2=tijRecord(iIncr,iel,isig,4);
     sig3=tijRecord(iIncr,iel,isig,7);
     sig4=tijRecord(iIncr,iel,isig,8);
     sig5=tijRecord(iIncr,iel,isig,9);
     sig6=tijRecord(iIncr,iel,isig,6);
     sig7=tijRecord(iIncr,iel,isig,3);
     sig8=tijRecord(iIncr,iel,isig,2);
     ColorFaceStress=[sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8];
     if (MaxStress < max(ColorFaceStress))
         MaxStress=max(ColorFaceStress);
     end
     if (MinStress > min(ColorFaceStress))
         MinStress=min(ColorFaceStress);
     end
     fill3(x(faceNode,1)+AmpFactor*disp(faceNode,1),y(faceNode,1)+AmpFactor*disp(faceNode,2),z(faceNode,1)+AmpFactor*disp(faceNode,3),ColorFaceStress);
     
end

hold off
hold off
grid

%axis([-50 50 -50 50 -200 300])
axis([-1 5 -0.2 0.2 -0.2 0.2])
view(20,42)
title(stresstitle(isig,:))
colorbar
% axes('position',[.05  .05  .9  .01])
% pcolor([1:0.1:10;1:0.1:10])
% set(gca,'XTickLabel',{MinStress:(MaxStress-MinStress)/8:MaxStress})
% set(gca,'YTickLabel',{''})
xlabel('x');ylabel('y');zlabel('z');
