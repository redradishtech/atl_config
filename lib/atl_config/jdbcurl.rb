require 'parslet'

module AtlConfig
	# Parses a JDBC URL in MySQL or Postgres formats.
	#
	# Current status: postgres parsing works 100%
	# mysql parsing works if the url looks like postgres's, but with the support for properties. 
	#
	# @todo The mysql case doesn't yet handle a blank hostname ('jdbc:mysql:///dbname'), and certainly doesn't handle multiple replication hosts.
	class JDBCURL

		# Given a JDBC URL, returns its constituent parts.
		# @param jdbcurl String E.g. +jdbc:mysql://localhost/wombles?foo=bar+ or +jdbc:postgresql://dbserver:5432/mydb+
		# @return [Hash{:dbtype => String, :host => String, :port => Integer, :database => String, :props => {:propkey => String, :propval => String}]
		def self.parse(jdbcurl)
			# first we get a hash with Parslet values, then we to_s each value to prevent our user seeing Parslet stuff.
			begin
			stringify(JDBCURLParser.new.parse(jdbcurl))
			rescue Parslet::ParseFailed => failure
				raise failure.cause.ascii_tree
			end
		end

		private

		def self.stringify(obj)
			if !obj then 
				nil
			elsif obj.kind_of?(Hash) then
				obj.inject({}) { |h, (k,v)|
					h[k] = stringify(v)
					h
				}
			elsif obj.kind_of?(Array) then
				obj.map { |x| stringify(x) }
			elsif obj.respond_to?(:to_s) then
				obj.to_s
			else
				raise "Unexpected AST from parser: got a #{obj.class}: #{obj}"
			end
		end

	end


	class BaseURLParser < Parslet::Parser
		rule(:database) { match['^?'].repeat.as(:database) }
		rule(:ipv6) { str('[') >> match('[^\]]').repeat.as(:host) >> str(']') }
		rule(:host) { (match[':/'].absent? >> any).repeat(1).as(:host) }
		rule(:host_or_ip) { (ipv6 | host) }
		rule(:port) { str(':') >> match('\d').repeat.as(:port) }
		rule(:propname) { match('[^=]').repeat.as(:propkey) }
		rule(:propval) { match('[^&]').repeat.as(:propval) }
		rule(:props) { str('?') >> propname >> str('=') >> propval >> (str('&') >> propname >> str('=') >> propval).repeat(0) }
	end


	# Per https://dev.mysql.com/doc/connector-j/en/connector-j-reference-configuration-properties.html, format is:
	# jdbc:mysql://[host1][:port1][,[host2][:port2]]...[/[database]] »
	# [?propertyName1=propertyValue1[&propertyName2=propertyValue2]...]
	#
	# but this is insane, so we only support the subset
	#
	# jdbc:mysql://[host1][:port1][/[database]] »
	# [?propertyName1=propertyValue1[&propertyName2=propertyValue2]...]
	#
	class MySQLURLParser < BaseURLParser
		rule(:expression) { str('jdbc:') >> str('mysql').as(:dbtype) >> str('://') >> host_or_ip.maybe >> port.maybe >> (str('/') >> database) >> props.as(:props).maybe }
		root :expression
		  #AtlConfig::JDBCURL.parse("jdbc:mysql:///redradish_confluence")
	end

	# Per https://jdbc.postgresql.org/documentation/80/connect.html, the Postgres formats are:
	#     jdbc:postgresql:database
	#     jdbc:postgresql://host/database
	#     jdbc:postgresql://host:port/database
	# plus parameters.
	class PostgreSQLURLParser < BaseURLParser
		#  To specify an IPv6 address your must enclose the host parameter with square brackets, for example:  jdbc:postgresql://[::1]:5740/accounting
		# With Postgres, a '//' indicates a host is definitely present. In MySQL the host may be omitted after the '//'
		rule(:host_and_port) { str('//') >> host_or_ip >> port.maybe >> str('/') }
		rule(:expression) { str('jdbc:') >> str('postgresql').as(:dbtype) >> str(':') >> host_and_port.maybe >> database >> props.as(:props).maybe }
		root :expression
		def parse(str)
			begin
				expression.parse(str)
			rescue Parslet::ParseFailed => failure
				raise %q{Invalid Postgres JDBC URL format. Valid formats are:
	     jdbc:postgresql:database
	     jdbc:postgresql://host/database
	     jdbc:postgresql://host:port/database
				} "\n" + failure.cause.ascii_tree
			end
		end
	end

	class JDBCURLParser < Parslet::Parser
		root :expression
		rule(:expression) { (MySQLURLParser.new | PostgreSQLURLParser.new) }
	end

	private_constant :JDBCURLParser, :BaseURLParser, :MySQLURLParser, :PostgreSQLURLParser

end
