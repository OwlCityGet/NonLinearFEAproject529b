function [tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel]=UpdateParametersVSDMMat(iGP,tijold,Mtijold,akpold,Myscold,epAcum,MepijAcum,tijoldel,Mtijoldel,akpoldel,Myscoldel,epAcumel,MepijAcumel)
 
    % Put the values of the parameters for the von Mises state determination for the gauss point study
    tijoldel(:,iGP)=tijold(:,1);
    Mtijoldel(iGP,:,:)=Mtijold(:,:);
    Myscoldel(iGP,:,:)=Myscold(:,:);
    akpoldel(1,iGP)=akpold;
    epAcumel(1,iGP)=epAcum;
    MepijAcumel(iGP,:,:)=MepijAcum(:,:);
    
end
