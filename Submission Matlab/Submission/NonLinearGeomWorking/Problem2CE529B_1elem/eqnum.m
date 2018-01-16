function [jj,ndf]=eqnum(jj,njoint,nv);
%****************************************************
%*     CREATES EQUATION NUMBERS                     *
%****************************************************
ndf=0;
for i=1:njoint;
   for k=1:nv,
      if (jj(i,k)~=0) ndf=ndf+1; end;
      if (jj(i,k)~=0) jj(i,k)=ndf; end;
   end;
end;