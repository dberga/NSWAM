function [smap] = get_combine_channels(loaded_struct,RF_c)
    switch (loaded_struct.fusion_params.smethod)
        case 'pmax2'
            smap = RF_c(:,:,1); %max opp i orient, los tres canales lo mismo
        case 'wta' 
            smap = channelwta(RF_c); %guanya nomes canal amb mes energia
        case 'pmax'  

            smap = channelmax(RF_c);	%maxim canals, despres de recons.
        case 'pmaxc'

            smap = RF_c(:,:,1); %maxim opp, los tres canales lo mismo
        case 'sqmean'
            smap = channelsqmean(RF_c);
        otherwise
            smap = channelsqmean(RF_c);
    end

end
