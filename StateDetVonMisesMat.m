function [MEt,mstat,tijold,Mtij,Myscnew,akpnew,epAcum,MepijAcum]=StateDetVonMisesMat(young,youngp,poisson,Vdet,tijold,Mtijold,Myscold,akpold,epAcum,MepijAcum,bet,erry)
%
%
% young     : Young Modulus
% youngp    : Young Modulus after Yielding 
% poisson   : poisson constant
% Vdet      : Vector that contains the incremental total strain 
% tijold    : the variable that storage the vector with the 6 stresses for the gauss point analyzed
% Mtijold   : the variable that storage the 3x3 stress matrix for the gauss point analyzed
% Myscold   : the variable that storage the 3x3 stress matrix with the yield surface center for the gauss point analyzed
% akpold    : the variable that storgare the Yield Stress for the gauss point analyzed
% epAcum    : the variable that storage the Acumulative or incremental Plastic Stretching for the gauss point analyzed
% MepijAcum : the variable that storage the Acumulative or incremental Plastic Stretching in each component for the gauss point analyzed
% erry      : parameter for Von Mises Material
% bet       : Kinematic Hardenig : 0 Isotropic Hardening : 1
% Mtij      : the variable that storage the new 3x3 stress matrix for the gauss point analyzed
% Myscnew   : the variable that storage the new 3x3 stress matrix with the yield surface center for the gauss point analyzed
% akpnew    : the variable that storgare the new Yield Stress for the gauss point analyzed
% MEt       : Material Matrix 6x6
% mstat     : parameter that returns if total stress value is inside or outside yield surface

end