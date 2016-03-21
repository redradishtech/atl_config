require 'test_helper'


class JDBCURLTest < Minitest::Test
  def test_that_it_has_a_version_number
	  refute_nil ::AtlConfig::VERSION
  end

#  def test_simple1
#	  # Test format    jdbc:postgresql:database
#	  assert_equal(
#		  {:dbtype=>"postgresql", :database=>"redradish_confluence"}, 
#		  AtlConfig::JDBCURLParser.new.host_or_ip.maybe.parse("sdf")
#					  )
#  end

  def test_simple
	  # Test format    jdbc:postgresql:database
	  assert_equal(
		  {:dbtype=>"postgresql", :database=>"redradish_confluence"}, 
		  AtlConfig::JDBCURL.parse("jdbc:postgresql:redradish_confluence"
					  )
	  )
  end
  def test_nonport
	  # Test format     jdbc:postgresql://host/database
	  assert_equal(
		  {:dbtype=>"postgresql", :host=>"localhost", :database=>"redradish_confluence"},
		  AtlConfig::JDBCURL.parse("jdbc:postgresql://localhost/redradish_confluence")
	  )
  end
  def test_nonport_ipv6
	  # TODO: Getting out of my depth as I don't actually use IPv6. Do we need to inform the user that :host is ipv6, or can it be inferred from the ::?
	  assert_equal(
		  {:dbtype=>"postgresql", :host=>"::1", :database=>"redradish_confluence"},
		  AtlConfig::JDBCURL.parse("jdbc:postgresql://[::1]/redradish_confluence")
	  )
  end
  def test_withport
	  # Test format     jdbc:postgresql://host:port/database
	  assert_equal(
		  {:dbtype=>"postgresql", :host=>"localhost", :port=>"5432", :database=>"redradish_confluence"},
		  AtlConfig::JDBCURL.parse("jdbc:postgresql://localhost:5432/redradish_confluence")
	  )
  end
  def test_mysql
	  assert_equal(
		  {:dbtype=>"mysql", :host=>"localhost", :port=>"3306", :database=>"redradish_confluence"},
		  AtlConfig::JDBCURL.parse("jdbc:mysql://localhost:3306/redradish_confluence")
	  )
  end
  def test_mysql_properties
	  assert_equal(
		  {:dbtype=>"mysql", :host=>"localhost", :port=>"3306", :database=>"redradish_confluence", :props => {:propkey => "key", :propval => "val"}},
		  AtlConfig::JDBCURL.parse("jdbc:mysql://localhost:3306/redradish_confluence?key=val")
	  )
	  assert_equal(
		  {:dbtype=>"mysql", :host=>"localhost", :port=>"3306", :database=>"redradish_confluence", :props => [{ :propkey => "key1", :propval => "val1"}, { :propkey => "key2", :propval => "val2"}]},
		  AtlConfig::JDBCURL.parse("jdbc:mysql://localhost:3306/redradish_confluence?key1=val1&key2=val2")
	  )
  end
  # FIXME: Omitting the host should work, thanks to the host_and_port_* rules,  but currently returns a bogus ':host=>[]' node.
  def test_mysql_blank_host
	  assert_equal(
		  {:dbtype=>"mysql", :database=>"redradish_confluence"},
		  AtlConfig::JDBCURL.parse("jdbc:mysql:///redradish_confluence"),
	  )
  end
  
end
