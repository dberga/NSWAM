function [smap] = get_combine_channels(loaded_struct,RF_c)
    switch (loaded_struct.fusion_params.smethod)
        case 'wta' 
            smap = channelwta(RF_c); %guanya nomes canal amb mes energia
        case 'sqmean'
            smap = channelsqmean(RF_c);
        otherwise %pmax, pmaxc, pmax2
            smap = channelmax(RF_c);
    end

end
