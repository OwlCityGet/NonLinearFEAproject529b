function FEA3D20_create_input
%
% Input Data Translator - ABAQUS -> FEA
%
% Steps for you to take:
%   1. copy the Abaqus input file to file FEA3D20_node.txt
%   2. Edit FEA3D20_node.txt and delete all lines except
%      the nodal coordinate data which occurs under
%      the name "NODE*" in the Abaqus input file.
%   3. copy the Abaqus input file to file FEA3D20_element.txt
%   4. Edit FEA3D20_element.txt and delete all lines except
%      the element connectivity data which occurs under
%      the name "ELEMENT*" in the Abaqus input file.
% Then this program does the following:
%   1. loads Abacus data from files FEA3D20_node.txt
%      and FEA3D20_element.txt

%   2. Transforms Abaqus data to FEA data.
%   3. Saves matlab FEA data for nodes and elements and

%      other data in FEA_input_data.mat.

%
%       

%We need to Set the Option 

%number of gauss point to use for the numerical integration : nGP= 2 or 3
nGP=3;

% Number of Node used for the 3D Brick Element nNodes= 20
nNodes=20;

% Number of History Load used in the Problem
nLoadHist=2;

% Number of Incrments Load used in between each Load History
nIncr=100;

% Maximun number of Iteration permited at Each Incerment Load Step
nIte=100;
MaxError=10^(-3);

% Nonlinear Geometry (Total Lagrangian method) Include: True=1 ; False=0
FlagNLG=1;

% Nonlinear Material [0 - Linear Elastic Material; 1 - Hyper-Elastic Matrial; 2 - Von Mises 3-D]
FlagNLM=0;

% We load the Joints for the Model
node=load('FEA3D20_node.txt'); 

% We load the element Connectivity
element=load('FEA3D20_element.txt'); 

num_node = size(node,1);

num_element = size(element,1);

% We write a matrix that storage the coordinate for each node
coord = node(:,2:4);

% To allow difference in local node number system
% between Abaqus and FEA
lotogo = zeros(size(element,1),20);

lotogo(:,1) = element(:,2);

lotogo(:,2) = element(:,3);

lotogo(:,3) = element(:,4);

lotogo(:,4) = element(:,5);

lotogo(:,5) = element(:,6);

lotogo(:,6) = element(:,7);

lotogo(:,7) = element(:,8);

lotogo(:,8) = element(:,9);

lotogo(:,9) = element(:,10);

lotogo(:,10) = element(:,11);

lotogo(:,11) = element(:,12);

lotogo(:,12) = element(:,13);

lotogo(:,13) = element(:,14);

lotogo(:,14) = element(:,15);

lotogo(:,15) = element(:,16);

lotogo(:,16) = element(:,17);

lotogo(:,17) = element(:,18);

lotogo(:,18) = element(:,19);

lotogo(:,19) = element(:,20);

lotogo(:,20) = element(:,21);

% Adding the boundary restraint conditions

%Set restraints to zero for nodes below "offset"

% jj = ones(size(coord));
% offset=0.0 ;
% ind = (abs(coord(:,1)+offset)<0.1); 
% jj(ind,:) = 0;

jj = ones(size(coord));

ind = 1; 
jj(ind,:) = [0 0 0];

ind = 22; 
jj(ind,:) = [0 0 0];

ind = 7; 
jj(ind,:) = [0 0 0];

ind = 13; 
jj(ind,:) = [0 0 0];

ind = 10; 
jj(ind,:) = [0 0 0];

ind = 24; 
jj(ind,:) = [0 0 0];

ind = 4; 
jj(ind,:) = [0 0 0];

ind = 20; 
jj(ind,:) = [0 0 0];

ind = 9; 
jj(ind,:) = [0 0 0];

ind = 31; 
jj(ind,:) = [0 0 0];

ind = 3; 
jj(ind,:) = [0 0 0];

ind = 29; 
jj(ind,:) = [0 0 0];

ind = 6; 
jj(ind,:) = [0 0 0];

ind = 32; 
jj(ind,:) = [0 0 0];

ind = 12; 
jj(ind,:) = [0 0 0];

ind = 26; 
jj(ind,:) = [0 0 0];


% Material property 
young =29*10^6;
poisson =0.3;


% Material Nonlinearity property
youngp =0;
akap=0;
bet=1;
erry=0.001;
%--------------------######################
% % Global nodes at which forces are applied 
% ind=zeros(size(coord,1),1);
% for i=1:size(coord,1)
%     if(abs(coord(i,1))>0.0199999996&&abs(coord(i,2)-1)>0.99*10^-2&&abs(coord(i,3)-1)>0.00999999978)
%         ind(i)=-1/12;
%     else
%         if(abs(coord(i,1))>0.0199999996&&(abs(coord(i,2)-1)<0.01*10^-2||abs(coord(i,3)-1)<0.01*10^-2))
%             ind(i)=1/3;
%         end
%     end
% end
% indC=0;
% ifornod=find(ind)';
% % force directions (1 - x, 2 - y, 3 - z)
% % Load in X : 1 direction 
% % Load in Y : 2 direction 
% % Load in Z : 3 direction 
% % force values 
% ifordir = 1*ones(1,size(ifornod,2));
% forval = ind(ifornod) ;

% ----------#########
ifornod = [2 18 5];
ifordir = 2*ones(1,size(ifornod,2));
P=1;
forval = [-P/6 -4*P/6 -P/6 ];
% -------############

%Load History
LoadHist=zeros(nLoadHist,1);
LoadHist(1,1)=0*10^8;
LoadHist(2,1)=8*10^8;



save FEA_input_data.mat coord lotogo jj nNodes nLoadHist nIncr nIte MaxError nGP FlagNLG FlagNLM young poisson youngp akap bet erry ifornod ifordir forval LoadHist;

