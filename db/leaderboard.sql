select distinct ult.username
from user_league_table as ult
where ult.lid = 999
order by balance DESC
;