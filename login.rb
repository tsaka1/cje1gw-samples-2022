#!/usr/local/bin/ruby
# $Id: login.rb,v 1.4 2022/06/03 16:43:18 saka Exp saka $

require("sqlite3")

# note: assume portno is a String
def portno_already_use (portno)
    IO.popen(["/usr/bin/netstat", "-an", "-p", "tcp"], "r"){ | io |
	while line = io.gets
	    f = line.split(' ')
	    if f[3] && i = f[3].rindex(".")
		i += 1
		l = f[3].size - i
		p = f[3][i,l]
		if portno == p
		    return true
		end
	    end
	end
    }
    return false
end

now = Time.now

if ARGV.length < 2
    puts(now)
    sleep(5)
    puts("Bye.")
    exit
end

case ARGV[1]
when "port"
    p = 0;
    d = "";
    db = SQLite3::Database.new("/home/example/gw/ports.db")
    while true
	db.transaction(:exclusive){
	    db.execute("select port, domain from ports order by tstamp asc limit 1;"){ | row |
		p = row[0].to_i
		d = row[1]
	    }
	    if p == 0
		puts("Something is wrong on ports.db.")
		exit
	    end
	    t = now.to_i
	    db.execute("update ports set tstamp = ? where port = ?;", t, p)
	}
	if !portno_already_use(p.to_s)
	    break
	end
    end
    db.close
    puts("+OK")
    puts(d)
    puts(p)
when "pycode"
    $stdout.binmode
    $stdout.write(IO.binread("/home/example/gw/pycode.tar.gz"))
when "pydebug"
    $stdout.binmode
    $stdout.write(IO.binread("/home/example/gw/pydebug.tar.gz"))
else
    puts("Unsupported Command: #{ARGV[1]}")
    puts(now)
    sleep(5)
    puts("Bye.")
end

exit
