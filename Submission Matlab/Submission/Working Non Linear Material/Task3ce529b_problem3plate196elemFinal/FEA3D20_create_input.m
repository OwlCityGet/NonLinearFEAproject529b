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
nIncr=50;

% Maximun number of Iteration permited at Each Incerment Load Step
nIte=100;
MaxError=10^(-3);

% Nonlinear Geometry (Total Lagrangian method) Include: True=1 ; False=0
FlagNLG=0;

% Nonlinear Material [0 - Linear Elastic Material; 1 - Hyper-Elastic Matrial; 2 - Von Mises 3-D]
FlagNLM=2;

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


jj = ones(size(coord));

offset = 0;
ind = (abs(coord(:,2)-offset)<1e-6);
jj(ind,2) = 0;

offset = 0;
ind = (abs(coord(:,1)-offset)<1e-6);
jj(ind,1) = 0;

offset = 0;
ind = (abs(coord(:,3)-offset)<1e-6);
jj(ind,3) = 0;



% Material property 
young =29.0*10.^6;
poisson =0.3;

% Material Nonlinearity property
youngp = 29.0*10.^5;
akap=6.0*10.^4 ;
bet=1;
erry=0.001;


% extremeCorner=[13 9 31 27];
% % ifordir = 2*ones(1,size(extremeCorner,2));
% % forval = -1*[ones(length(extremeCorner))];
% 
% midMid=[1024 1018 1327 1084 1081 1390 1144 1141 1428 1204 1201 1466 1264 1261 1504 1324 1321 1542 ...
%     2398 2375 2491 2372 2315 2496 2312 2255 2501 2252 2195 2506 2192 2135 2511 2129];
% % ifordir = 2*ones(1,size(midMid,2));
% % forval = 8*ones(length(midMid));
% 
% midCorner=[106:110 12 250:254];
% % ifordir = 2*ones(1,size(midCorner,2));
% % forval = -4*[ones(length(midCorner))];
% 
% edgeCorner=[10 111:115 11 234:238 143 :147 15 271:275 ];
% % ifordir = 2*ones(1,size(edgeCorner,2));
% % forval = -2*[ones(length(edgeCorner))];
% 
% edgeCenter=[1021 1328 1331 1023 1083 1391 1429 1143 1203 1467 1263 1505 1323 1453 2399 2488 2373 2493 ...
%     2313 2498 2253 2503 2193 2508 2132 2513 2134 2516];
% % ifordir = 2*ones(1,size(edgeCenter,2));
% % forval = 4*[ones(length(edgeCenter))];
 
extremeCorner=[9 11 128 130];
% % ifordir = 2*ones(1,size(edgeCenter,2));
% % forval = 4*[ones(length(extCor))];

midEdge=[470 464 511 556 601 606 614 622 630 637 635 627 619 611 604 559 514 467];
% % ifordir = 2*ones(1,size(edgeCenter,2));
% % forval = 4*[ones(length(edgMid))];

midMid=[469 515 560 605 613 621 629];
% % ifordir = 2*ones(1,size(edgeCenter,2));
% % forval = 4*[ones(length(midMid))];

edgeCorner=[41 42 43 10 52 53 54 173 172 171 129 162 161 160];
% % ifordir = 2*ones(1,size(edgeCenter,2));
% % forval = 4*[ones(length(edgCor))];



% ----------#########
ifornod = [extremeCorner midEdge midMid edgeCorner];
ifordir = 2*ones(1,size(ifornod,2));
forval = [-1*ones(1,length(extremeCorner)) 4*ones(1,length(midEdge)) 8*ones(1,length(midMid)) -2*ones(1,length(edgeCorner))];
% -------############

% ind([6 5 1 2])=(-1/12);
% ind([12 18 13 17])=(1/3);
% ifornod=find(ind);
% 
% ifordir_z=3*ones(1,size(ifornod,2));
% ifordir=[ifordir_z];
% forval=[ind(ifornod)] ;
% ifornod=[ifornod];

%Load History
LoadHist=zeros(nLoadHist,1);
LoadHist(1,1)=0*10^6;

LoadHist(2,1)=6.0*10^2 ;
% LoadHist(3,1)=32.0*10^5 ;
% LoadHist(4,1)=46.0*10^5 ;
% LoadHist(5,1)=-20.0*10^5 ;
% LoadHist(6,1)=-50.0*10^5;
% LoadHist(7,1)=30.0*10^5 ;
% LoadHist(8,1)=56.0*10^5;





save FEA_input_data.mat coord lotogo jj nNodes nLoadHist nIncr nIte MaxError nGP FlagNLG FlagNLM young poisson youngp akap bet erry ifornod ifordir forval LoadHist;

