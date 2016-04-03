require 'test_helper'

class ServerXMLTest < Minitest::Test
	def setup
		@serverxml = IO.read("test/server.xml")
	end

	def test_strip_compenv
		ds = AtlConfig::ServerXML.dbinfo(@serverxml, "jdbc/ConfDS")
		ds2 = AtlConfig::ServerXML.dbinfo(@serverxml, "java:comp/env/jdbc/ConfDS")
		assert_equal(ds, ds2)
	end

	def test_nonexistent_datasource
		ds = AtlConfig::ServerXML.dbinfo(@serverxml, "jdbc/Nonexistent")
		assert_nil(ds)
	end

	def test_confluence_datasource
		ds = AtlConfig::ServerXML.dbinfo(@serverxml, "jdbc/ConfDS")
		assert_equal("redradish_confluence", ds.user)
		assert_equal("postgresql", ds.dbtype)
		assert_equal("redradish_confluence", ds.user)
		assert_equal("redradish_confluence", ds.password)
		assert_equal("redradish_confluence", ds.database)
		assert_equal("localhost", ds.host)
		assert_equal("jdbc:postgresql://localhost/redradish_confluence", ds.jdbcurl)
		assert_equal("postgres://localhost/redradish_confluence", ds.dburl)

		ds = AtlConfig::ServerXML.dbinfo(@serverxml, "jdbc/PluginStats")
		assert_equal("redradish_confluence", ds.user)
		assert_equal("postgresql", ds.dbtype)
		assert_equal("redradish_confluence", ds.user)
		assert_equal("redradish_confluence", ds.password)
		assert_equal("pluginstats", ds.database)
		assert_equal("jdbc:postgresql://localhost/pluginstats", ds.jdbcurl)
		assert_equal("postgres://localhost/pluginstats", ds.dburl)
	end
end
