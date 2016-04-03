require 'test_helper'

class JIRAConfigTest < Minitest::Test
	def test_jira_directjdbc
		cfg = AtlConfig::JIRAConfig.dbinfo IO.read("test/jira/dbconfig.xml-directjdbc")
		assert_equal("postgresql", cfg.dbtype)
		assert_equal("redradish_jira", cfg.user)
		assert_equal("redradish_jira", cfg.password)
		assert_equal("localhost", cfg.host)
		assert_equal("redradish_jira", cfg.database)
		assert_equal("jdbc:postgresql://localhost:5432/redradish_jira", cfg.jdbcurl)
		assert_equal("postgres://localhost:5432/redradish_jira", cfg.dburl)
		assert_nil(cfg.datasource)
	end

	def test_jira_datasource
		cfg = AtlConfig::JIRAConfig.dbinfo IO.read("test/jira/dbconfig.xml-datasource")
		assert_equal("java:comp/env/jdbc/JiraDS", cfg.datasource)
		assert_nil(cfg.dbtype)
		assert_nil(cfg.user)
		assert_nil(cfg.password)
		assert_nil(cfg.host)
		assert_nil(cfg.database)
		assert_nil(cfg.jdbcurl)
		assert_nil(cfg.dburl)
	end
end
