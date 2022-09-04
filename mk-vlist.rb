#!/usr/local/bin/ruby

require("sqlite3")

db = SQLite3::Database.new("ports.db")
db.transaction(:exclusive){

    db.execute("select port, domain from ports order by port asc;"){ | row |
	port = row[0].to_i
	dom = row[1]

print <<EOS
<VirtualHost *:80>
    ServerAdmin foo@example.com
    DocumentRoot "/home/example/public_html/bar"
    ServerName #{dom}.gw.example.com
    ErrorLog "/var/log/httpd-gw.example.com-error.log"
    CustomLog "/var/log/httpd-gw.example.com-access.log" combined
    ProxyPass / http://localhost:#{port}/
    ProxyPassReverse / http://localhost:#{port}/
    ProxyPassReverseCookieDomain localhost #{dom}.gw.example.com
    ProxyPassReverseCookiePath / /
</VirtualHost>

EOS

    }

}

db.close
