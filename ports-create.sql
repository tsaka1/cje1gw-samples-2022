create table if not exists
    ports (
	port int primary key,
	domain text unique,
	tstamp int
    );

create index if not exists
    ports_idx on ports (tstamp);
