# Library for parsing Atlassian product config files.
#
# Currently contains only the {dbinfo} static function.

module AtlConfig
	# Valid values for {dbinfo}
	KNOWNPRODUCTS = ["confluence", "jira-software", "jira-core"]

	# Get database connection details for a JIRA/Confluence instance.
	# @param product [String] Either 'confluence', 'jira-software' or 'jira-core' 
	# @param appdir [String] Path to app directory, e.g. '/opt/atlassian/jira'
	# @param datadir [String] Path to data directory, e.g. '/var/atlassian/application-data/jira'
	# @return [AtlConfig::DBInfo] object with database details.
	#
	def self.dbinfo(product, appdir, datadir)
		raise "Null appdir" unless appdir
		raise "Null datadir" unless datadir
		appdir = Pathname.new(appdir)
		datadir = Pathname.new(datadir)
		raise "Product '#{product}' is not one of known products: #{KNOWNPRODUCTS.join(", ")}" unless KNOWNPRODUCTS.member? product
		raise "Nonexistent appdir '#{appdir.inspect}'" unless appdir.exist?
		raise "Nonexistent datadir '#{datadir.inspect}'" unless datadir.exist?

		dbinfo = case product 
		       when /jira.*/
			       AtlConfig::JIRAConfig.dbinfo(IO.read(datadir + "dbconfig.xml"))
		       when "confluence"
			       AtlConfig::ConfluenceCfg.dbinfo(IO.read(datadir + "confluence.cfg.xml"))
		       end
		if dbinfo.datasource then
			AtlConfig::ServerXML.dbinfo(IO.read(appdir + "conf" + "server.xml"), dbinfo.datasource)
		else
			dbinfo
		end
	end
end
