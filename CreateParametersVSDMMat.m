function [Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum]=CreateParametersVSDMMat(iGP,alfaDd,FlagNLG,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel)

    if FlagNLG==1
        % Determinate the Matrix 3x3  that Contains the incremental strain for NonLinear Geometry 
        MstrainDd=1/2*(alfaDd+alfaDd'+alfaDd*alfaDd');
    else
        % Determinate the Matrix 3x3  that Contains the incremental strain for small deformation case
        MstrainDd=1/2*(alfaDd+alfaDd');
    end
    
    % Create the vector that Contains the incremental strain
    Vdet=zeros(6,1);
    
    for i=1:3
        Vdet(i,1)=MstrainDd(i,i);
    end    
    Vdet(4,1)=2*MstrainDd(1,2);
    Vdet(5,1)=2*MstrainDd(2,3);
    Vdet(6,1)=2*MstrainDd(3,1);
    
    % Initialized the matrix that store the parameters for the von Mises state determination for the gauss point study
    tijold=zeros(6,1);
    Mtijold=zeros(3,3);
    Myscold=zeros(3,3);
    MepijAcum=zeros(3,3);
    
    % Put the values of the parameters for the von Mises state determination for the gauss point study
    tijold(:,1)=tijoldel(:,iGP);
    Mtijold(:,:)=Mtijoldel(iGP,:,:);
    Myscold(:,:)=Myscoldel(iGP,:,:);
    akpold=akpoldel(1,iGP);
    epAcum=epAcumel(1,iGP);
    MepijAcum(:,:)=MepijAcumel(iGP,:,:);
    
end
