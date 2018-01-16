%Scrip that Assemble the Tangent Stiffness matrix and the Residual vector
for i=1:nNodes
    for k=1:nNodes
        icon=lotogo(iel,i);
        kcon=lotogo(iel,k);
        for ii=1:3,
            for kk=1:3,
                iicon=jj(icon,ii);
                kkcon=jj(kcon,kk);
            	iii=(i-1)*3+ii;
                kkk=(k-1)*3+kk;
                if (iicon ~= 0 && kkcon ~= 0)
                    if (iicon <= kkcon),
                    	ilp=maxa(kkcon)+kkcon-iicon;
                    	a(ilp)=a(ilp)+akloc(iii,kkk);
                    end
                end
                if (k==1 && kk==1)
                    if (iicon~=0)
                    	fRes(iicon)=fRes(iicon)+fel(iii);
                    end
                end
            end
        end
    end
end
