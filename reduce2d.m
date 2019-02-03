function[Id] = reduce2d(I)
mn = size(I)/2; %find size of I and half it
IDCT = dct2(I); %apply DCT
Id = round(idct2(IDCT(1:mn(1),1:mn(2))));   %apply IDCT on half of DCT so we get reduce result