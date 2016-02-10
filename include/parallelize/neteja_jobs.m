 	jm=findResource('scheduler','type','jobmanager','Name','xotazu','LookupURL','localhost')

 	get(jm)
 
	% destroy any existing job
		
 	jo= findJob(jm);
 	destroy(jo);
jo;