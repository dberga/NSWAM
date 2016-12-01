function [ opp_img ] = get_rgb2opp( rgb_img, struct )
    opp_img = get_the_cstimulus(rgb_img,struct.color_params.gamma,struct.color_params.srgb_flag);
    
end

