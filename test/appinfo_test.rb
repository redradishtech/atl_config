require 'test_helper'
require 'pathname'


class JDBCURLTest < Minitest::Test
	def setup
		@dir = Pathname.new(Dir.mktmpdir)
		@appdir = (@dir + "appdir" + "conf")
		@appdir.mkpath
		FileUtils.cp "test/server.xml", (@appdir + "server.xml")
		@datadir = (@dir + "datadir")
		@datadir.mkpath
		FileUtils.cp "test/jira/dbconfig.xml-directjdbc", (@datadir + "dbconfig.xml")
	end
	def test_product_checked
		assert_raises(RuntimeError) {
			AtlConfig.dbinfo("invalid", nil, nil)
		}
		assert_raises(Errno::ENOENT) {
			refute_nil AtlConfig.dbinfo("jira-software", '/tmp', '/tmp')
		}
		refute_nil AtlConfig.dbinfo("jira-software", @appdir, @datadir)
	end
	def test_foo
		info = AtlConfig.dbinfo("jira-software", @appdir, @datadir)
		refute_nil info
		assert_equal("redradish_jira", info.database)
	end

	def teardown
		@dir.rmtree
	end
end
