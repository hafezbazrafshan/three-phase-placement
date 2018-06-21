Data=readtable( 'pvwatts_hourly.csv');
Hours=cellfun(@str2num,Data.Hour(1:end-1)); 
AcOutput=cellfun(@str2num,Data.ACSystemOutput_W_(1:end-1));
AcRated=4000/1.1;
ValidData=AcOutput(and(Hours>=6,Hours<=18))./AcRated;
save('PvData','ValidData'); 
