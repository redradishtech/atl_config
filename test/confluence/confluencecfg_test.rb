require 'test_helper'

class ConfluenceCfgTest < Minitest::Test
	def test_confluence_directjdbc
		cfg = AtlConfig::ConfluenceCfg.dbinfo IO.read("test/confluence/confluence.cfg.xml-directjdbc")
		assert_equal("postgresql", cfg.dbtype)
		assert_equal("redradish_confluence", cfg.user)
		assert_equal("redradish_confluence", cfg.password)
		assert_equal("localhost", cfg.host)
		assert_equal("redradish_confluence", cfg.database)
		assert_equal("jdbc:postgresql://localhost:5432/redradish_confluence", cfg.jdbcurl)
		assert_equal("postgres://localhost:5432/redradish_confluence", cfg.dburl)
		assert_nil(cfg.datasource)
	end

	def test_confluence_datasource
		cfg = AtlConfig::ConfluenceCfg.dbinfo IO.read("test/confluence/confluence.cfg.xml-datasource")
		assert_equal("java:comp/env/jdbc/ConfDS", cfg.datasource)
		assert_nil(cfg.dbtype)
		assert_nil(cfg.user)
		assert_nil(cfg.password)
		assert_nil(cfg.host)
		assert_nil(cfg.database)
		assert_nil(cfg.jdbcurl)
		assert_nil(cfg.dburl)

	end
end
