clear;
close all;
clc;

Io=double(imread('lena_color.jpg'));      %read original image
[m1,n1,o1]=size(Io);        %find size of it
Iw=double(imresize(imread('coin.jpg'),[m1,n1]));   %read watermark image and resize with original

% display original image
figure;         
imshow(uint8(Io),[]);
title('Original image');

% display watermark image
figure;
imshow(uint8(Iw),[]);
title('Watermark image');

for cl=1:size(Io,3)     %for gray scale, it run for one time and for RGB, it wun 3 times

IM1=Io(:,:,cl);     %take one by one colour data(R-G-B)
if size(Iw,3)==1    %if watermark image is gray scale,
    IM2=Iw;     %take it is
else
    IM2=Iw(:,:,cl);     %else take colour data with original colour band
end


% watermarking
k=8;    %level of pyramid

% Reduce size and resolution
for i=1:k
    IM = reduce2d(IM1);       %reduce size, R operator in paper (R(I))
    Id1 = IM1 - expand2d(IM);   %find error
    IM1 = IM;       %assign into IM1 to run in loop
    IM = reduce2d(IM2);     %reduce size, R operator in paper (R(I))
    
    Id2 = IM2 - expand2d(IM);   %find error
    IM2 = IM;   %assign into IM2 to run in loop
    C1{i}=Id1;      %save error which will be used in reconstruction
    C2{i}=Id2;
end
alpha=0.05;     %value of alpha in watermarking
gd=IM1+alpha.*IM2;  %watermark two image

% expand size and resolution
for i=k:-1:1
    gd = expand2d(gd)+C1{i};    %expand image and add with error (inverse process of pyramid)
end
Iwatermark(:,:,cl) = gd;    %save watermark result in appropriate colour format



Iwatermark(:,:,cl)=JPEGAttack(Iwatermark(:,:,cl));  %apply JPEG attack
IW1=Iwatermark(:,:,cl);

% same as previous, i.e. make pyramid, extract watermark image and inverse
% of pyramid to getting spatial image with same resolution of original
% watermark image

%reduce size and resolution
for i=1:k
    IW = reduce2d(IW1);       %g1
    Id1 = IW1 - expand2d(IW);   %I0
    IW1 = IW;
%     C3{i}=Id1;
end

Ir = (IW1-IM1)./alpha;  %extract watermark information

%expand size and resolution
for i=k:-1:1
    Ir = expand2d(Ir)+C2{i};
end
Ireconstructed(:,:,cl) = Ir;

end
figure;
imshow(uint8(Iwatermark),[]);
title('Watermarked image');

figure;
imshow(uint8(Ireconstructed),[]);
title('Watermark extracted');

psnrValue1 = psnr(uint8(Iw),uint8(Ireconstructed));
psnrValue2 = psnr(uint8(Io),uint8(Iwatermark));

%display(['PSNR between Watermark Image and Reconstructed watermark image is ',num2str(psnrValue1)]);
display(['PSNR between Original Image and Watermarked image is ',num2str(psnrValue2)]);