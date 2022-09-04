#!/usr/local/bin/ruby

require("sqlite3")
require("digest/md5")


e = 20000
n = 10000

db = SQLite3::Database.new("ports.db")
db.transaction(:exclusive){

    while n < e
	x = n.to_s(16)
	d = Digest::MD5.hexdigest(x)
	(snip: この d と x を使ってユニークな文字列を生成)

	t = Time.now.to_i

	db.execute("insert into ports (port, domain, tstamp) values (?, ?, ?);",
		n, dom, t)

	n += 1
    end

}

db.close

