function c_img = decorrect_gamma(img, gamma)
    img_sRGB_temp1 = (img*12.92).*(img <= 0.0031308);
    img_sRGB_temp2 = ((1+0.055)*(img.^(1/gamma))-0.055).*(img > 0.0031308);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;

    c_img = img_sRGB;
end