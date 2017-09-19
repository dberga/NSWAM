function [  ] = smail( address,body,subject )

system(['echo "' body '" | mail -s "' subject '" ' address]);

end