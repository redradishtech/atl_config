require 'test_helper'
require 'pathname'

# Tests AtlConfig.dbinfo.
# dbinfo is a pretty simple class that returns a 'dbinfo' for either JIRA or Confluence.
class JDBCURLTest < Minitest::Test
	def setup
		@dir = Pathname.new(Dir.mktmpdir)
		@appdir = (@dir + "appdir" + "conf")
		@appdir.mkpath
		FileUtils.cp "test/server.xml", (@appdir + "server.xml")
		@datadir = (@dir + "datadir")
		@datadir.mkpath
		FileUtils.cp "test/jira/dbconfig.xml-directjdbc", (@datadir + "dbconfig.xml")
		FileUtils.cp "test/confluence/confluence.cfg.xml-directjdbc", (@datadir + "confluence.cfg.xml")
	end
	def test_product_checked
		assert_raises(RuntimeError) {
			AtlConfig.dbinfo("invalid", nil, nil)
		}
	end
	def test_app_and_data_dirs_checked
		assert_raises(Errno::ENOENT) {
			refute_nil AtlConfig.dbinfo("jira-software", '/tmp', '/tmp')
		}
	end

	def test_jira_parsing_works
		cfg = AtlConfig.dbinfo("jira-software", @appdir, @datadir)
		refute_nil cfg
		# Note: here we test only that the right product config was found. Fuller testing of cfg is done by test/jira/jiraconfig_test.rb
		assert_equal("redradish_jira", cfg.database)
	end

	def test_confluence_parsing_works
		cfg = AtlConfig.dbinfo("confluence", @appdir, @datadir)
		refute_nil cfg
		assert_equal("redradish_confluence", cfg.database)
	end

	def teardown
		@dir.rmtree
	end
end
