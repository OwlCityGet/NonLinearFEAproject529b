function [ShapeFM]=CreateShapeFM(shapeF)

ShapeFM=zeros(60,3);

for i=1:20
    for id=1:3
        ShapeFM((i-1)*3+id,id)=shapeF(i,1);
    end
end


