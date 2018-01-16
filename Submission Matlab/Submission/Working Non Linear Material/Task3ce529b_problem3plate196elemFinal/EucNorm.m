function l2=EucNorm(mat)
l2=0;
for i=1:size(mat,2)
    for j=1:size(mat,2)        
        l2=l2+mat(i,j)*mat(i,j);
    end
end
l2=sqrt(l2);
end