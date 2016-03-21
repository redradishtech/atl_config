require 'nokogiri'
module AtlConfig
	class ConfluenceCfg
		# Extracts database info from Confluence +confluence.cfg.xml+ files.
		# @param cfgxml [String] XML Text of +confluence.cfg.xml+ file
		# @return [DBInfo] 
		def self.dbinfo(cfgxml)
			config = Nokogiri::XML(cfgxml)
			r = DBInfo.new
			r.datasource = config.xpath("/confluence-configuration/properties/property[@name='hibernate.connection.datasource']/text()").first&.to_s
			if !r.datasource then
				base = config.xpath("/confluence-configuration/properties")
				r.user = base.xpath("property[@name='hibernate.connection.username']/text()").first&.to_s
				r.password = base.xpath("property[@name='hibernate.connection.password']/text()").first&.to_s
				url = base.xpath("property[@name='hibernate.connection.url']/text()").first&.to_s
				urlparts = AtlConfig::JDBCURL.parse(url)
				r.dbtype = urlparts[:dbtype]
				r.host = urlparts[:host]
				r.port = if urlparts[:port] then urlparts[:port].to_i
					else
						case @dbtype
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
