require 'nokogiri'
module AtlConfig
	class JIRAConfig
		# Extracts database info from JIRA +dbconfig.xml+ files.
		# @param cfgxml [String] XML Text of +dbconfig.xml+ file
		# @return [DBInfo] 
		def self.dbinfo(cfgxml)
			config = Nokogiri::XML(cfgxml)
			r = DBInfo.new
			r.datasource = config.xpath("/jira-database-config/jndi-datasource/jndi-name/text()").first&.to_s
			if !r.datasource then
				base = config.xpath("/jira-database-config/jdbc-datasource")
				r.user = base.xpath("username/text()").first&.to_s
				r.password = base.xpath("password/text()").first&.to_s
				url = base.xpath("url/text()").first&.to_s
				urlparts = AtlConfig::JDBCURL.parse(url)
				r.dbtype = urlparts[:dbtype]
				r.host = urlparts[:host]
				r.port = if urlparts[:port] then urlparts[:port].to_i
					else
						case r.dbtype
						when 'postgresql'
							5432
						when 'mysql'
							3306
						else
							raise "Unhandled db type #{dbtype}"
						end
					end
				r.database = urlparts[:database]
			end
			r
		end
	end
end
