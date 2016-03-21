require 'nokogiri'
module AtlConfig

	class ServerXML
		# Extracts database info from a datasource definition in a Tomcat +server.xml+ files.
		# @param cfgxml [String] XML Text of +conf/server.xml+ file
		# @param dsname [String] Name of datasource defined in XML 
		# @return [DBInfo] 
		def self.dbinfo(cfgxml, dsname)
			config = Nokogiri::XML(cfgxml)
			dsname = dsname.gsub(/^java:comp\/env\//, '')
			datasource = config.xpath("/Server/Service/Engine[@name='Standalone']/Host[@name='localhost']/Context/Resource[@name='#{dsname}']").first
			if datasource then
				r = DBInfo.new
				r.user = datasource.xpath("@username")&.to_s
				r.password = datasource.xpath("@password")&.to_s
				url = datasource.xpath("@url")&.to_s
				if url then
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
								raise "Unhandled db type #{r.dbtype}"
							end
						end
					r.database = urlparts[:database]
				end
				r
			else
				nil
			end
		end
	end
end
