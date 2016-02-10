compute.dir={'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic'};
p = compute.dir;

jm = findResource('scheduler', 'type', 'jobmanager', 'Name', 'xcerda-10', 'LookupURL', 'localhost');
get(jm);
job = createJob(jm);
set(job,'FileDependencies',p);
set(job,'PathDependencies',p);
get(job);

for i=1:5
	t = createTask(job, @prova, 1, {i});
end

submit(job);
get(job,'Tasks');
waitForState(job, 'finished');

for i=1:5
        job.Tasks(i).ErrorMessage;
end

out = getAllOutputArguments(job);
out
destroy(job);

exit
