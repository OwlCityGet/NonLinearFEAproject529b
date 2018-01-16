function [pos,weight]=GaussPoint(nGP,GP)
% Return the gauss point weight 
if nGP==1
    weight=2;
    pos=0;
end

if nGP==2
    weight=1;
    if GP==1
        pos=-1/sqrt(3);
    else
        pos=1/sqrt(3);
    end        
end

if nGP==3
    if GP==1
        pos=-sqrt(0.6);
        weight=5/9;
    else
        if GP==2
            pos=0;
            weight=8/9;
        else
            pos=sqrt(0.6);
            weight=5/9;  
        end        
    end        
end

end
