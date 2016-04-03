require "atl_config/version"
require "atl_config/jdbcurl"
require "atl_config/confluencecfg"
require "atl_config/jiraconfig"
require "atl_config/serverxml"
require "atl_config/appinfo"

module AtlConfig
	# Struct containing database connection info.
	DBInfo = Struct.new :datasource, :user, :password, :dbtype, :host, :port, :database, :jdbcurl, :dburl
end
