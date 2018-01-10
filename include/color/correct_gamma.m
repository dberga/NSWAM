function c_img = correct_gamma(img, gamma)
    img_sRGB_temp1 = (img/12.92).*(img <= 0.04045);
    img_sRGB_temp2 = (((img + 0.055)/1.055).^gamma).*(img > 0.04045);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;
    c_img = img_sRGB;
end