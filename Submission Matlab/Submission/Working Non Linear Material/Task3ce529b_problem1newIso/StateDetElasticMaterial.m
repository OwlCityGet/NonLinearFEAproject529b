function [Et,tijel,Mtijel]=StateDetElasticMaterial(young,poisson,alfa,FlagNLG)
% Et     : Material Matrix 6x6
% tijel  : vector with the 6 stresses for the gauss point analyzed
% Mtijel : 3x3 Matrix stress for the gauss point analyzed

    %Create the Elastic Matrix for the 
    Et=zeros(6,6);
    p=poisson;
    Ed=[1-p p p 0 0 0;
        p 1-p p 0 0 0;
        p p 1-p 0 0 0;
        0 0 0 (1-2*p)/2 0 0;
        0 0 0 0 (1-2*p)/2 0;
        0 0 0 0 0 (1-2*p)/2];
    
    Et=(Ed*young/((1+p)*(1-2*p)));
    
    gama33= 0.5*(alfa'+alfa + alfa'*alfa);
    gama=[gama33(1,1) gama33(2,2) gama33(3,3) 2*gama33(1,2)  2*gama33(1,3) 2*gama33(2,3)]';
    
    tijel=Et*gama;
    
    Mtijel=[tijel(1,1) tijel(4,1) tijel(5,1);
            tijel(4,1) tijel(2,1) tijel(6,1);
            tijel(5,1) tijel(6,1) tijel(3,1)];
        
end
