function [d]=Distance_XOP(xx,yy,type)


switch type
	case ('eucl')
		d=sqrt(xx.*xx+yy.*yy);
	case ('manh')
		d=abs(xx)+abs(yy);
	otherwise
		disp ('ERRORRRR!!!! La distancia no esta ben especificada!!!!!');
end

end