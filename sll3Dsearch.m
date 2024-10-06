%This function allows to calculate the over all sll
function sllValue = sll3Dsearch (radPatt3D)

    ix = find(imregionalmax(radPatt3D));
    [maxRad, maxPos] = sort(radPatt3D(ix), 'descend');
    sllValue = maxRad(1)-maxRad(2);

end