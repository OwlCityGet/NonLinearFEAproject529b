%OUTPUT THE RESULTING DISPLACEMENTS AND THE INTPUTS
%We start printing the Head of the Output File

fprintf(fid,'\n');
fprintf(fid,'FEA Finite Element Calculation\n');
fprintf(fid,'\n');

%PRINT PROBLEM SIZE PARAMETERS
fprintf(fid,'Number of joints and number of elements:');
fprintf(fid,'%6.2f  %6.2f\n',njoint,nel);
fprintf(fid,'\n');

%PRINT MATERIAL DATA
fprintf(fid,'modulus of elasticity:');
fprintf(fid,'%6.2f\n',young);
fprintf(fid,'poisson ratio:');
fprintf(fid,'%6.2f\n',poisson);
fprintf(fid,'\n');

%PRINT NODE GLOBAL CCORDINATES
fprintf(fid,'Joint coordinates-INOD:\n');
for inod=1:njoint
    xnode=coord(inod,1);
    ynode=coord(inod,2);
    znode=coord(inod,3);
    fprintf(fid,'%6.2f %6.2f %6.2f %6.2f\n',inod,xnode,ynode,znode);
end ;
fprintf(fid,'\n');

%PRINT JOINT RESTRAINT CODES
fprintf(fid,'Joint Restraints at node point-INOD:\n');
for inod=1:njoint
    jj1=jjjj(inod,1);
    jj2=jjjj(inod,2);
    jj3=jjjj(inod,3);
    fprintf(fid,'%3.0f %3.0f %3.0f %3.0f\n',inod,jj1,jj2,jj3);
end ;
fprintf(fid,'\n');

%PRINT ELEMENT CONNECTIVITY
fprintf(fid,'Connectivity-IEL:\n');
for iel=1:nel
    conn=lotogo(iel,1:nNodes);
    fprintf(fid,'%3.0f %3.0f %3.0f %3.0f %3.0f %3.0f %3.0f %3.0f %3.0f\n',iel,conn);
end ;
fprintf(fid,'\n');

%PRINT EQUATION NUMBERS
fprintf(fid,'Degrees of Freedom point-INOD:\n');
for inod=1:njoint
    jj1=jj(inod,1);
    jj2=jj(inod,2);
    jj3=jj(inod,3);
    fprintf(fid,'%3.0f %3.0f %3.0f %3.0f\n',inod,jj1,jj2,jj3);
end ;
fprintf(fid,'\n');
