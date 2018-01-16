%This Scrip Write the Output Values for the Problem Study

fprintf(fid,'Increment : %3.0f of %3.0f',iIncr,nIncr);
fprintf(fid,'\n');

%PRINT CONCENTRATED FORCES
fprintf(fid,'Concen. Forces-I,IFORNOD,IFORDIR,FORVAL for Increment: %3.0f\n',iIncr);
for i=1:nfor,
    inod=ifornod(i);
    idir=ifordir(i);
    fprintf(fid,'%3.0f %3.0f %3.0f %6.2f\n',i,inod,idir,(iIncr/nIncr)*forval(i));
end;
fprintf(fid,'\n');

%PRINT COMPUTED NODAL DISPLACEMENT
fprintf(fid,'Output displacements-INOD for Increment: %3.0f\n',iIncr);
for inod=1:njoint
    jj1=jj(inod,1);
    d1=0;
    if (jj1~=0) 
       d1=d1+d(jj1); 
    end
    jj2=jj(inod,2);
    d2=0;
    if (jj2~=0)
       d2=d2+d(jj2);
    end
    jj3=jj(inod,3);
    d3=0;
    if (jj3~=0) 
       d3=d3+d(jj3);
    end
    fprintf(fid,'%3.0f %6.4f %6.4f %6.4f\n',inod,d1,d2,d3);
end ;
fprintf(fid,'\n');

%LOOP ON THE NUMBER OF ELEMENTS-COMPUTE ELEMENT STRESSES

stressEle=zeros(6,nGP^3);

for iel=1:nel,
      
    for i=1:6
        for j=1:(nGP^3)
            stressEle(i,j)=tijRecord(iIncr,iel,i,j);
        end
    end    
   
    %Print Computed Stresses at Each Gauss Point at each the Element
    fprintf(fid,'Output Stresses at Each Gauss Point for element : %3.0f\n',iel);
    for ipt=1:(nGP^3)
        fprintf(fid,'%3.0f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f\n',ipt,stressEle(:,ipt)');
    end 

end 
fprintf(fid,'\n');