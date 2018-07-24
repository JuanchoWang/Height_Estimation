function  [H t] = generateHomography(KR,elevation)

 t = KR*[0;0;-elevation];

 H = [KR];
 H(:,3) = t;

