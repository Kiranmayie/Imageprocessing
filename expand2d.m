function[Ie] = expand2d(I)
mn = size(I)*2; %find size of I and double it
IDCT = dct2(I);     %apply DCT
Ie = idct2(IDCT,[mn(1) mn(2)]);     %apply IDCT after paddind zeros to get two times of size