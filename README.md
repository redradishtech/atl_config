# Atlassian Configuration File Parsers

Say one wishes to write a Ruby script that pokes around in the JIRA or Confluence database for some reason. The first step would be to infer the database details, configured either in the application (`dbconfig.xml`, `confluence.cfg.xml`) or in the appserver (`conf/server.xml`).

This library handles the business of figuring out where the database details are stored. Just give the `dbinfo` function the location of the data dir (e.g. `JIRA_HOME`) and application directory.


## Usage

Sample use:


	[1] pry(main)> require 'atl_config'
	=> true
	[2] pry(main)> AtlConfig.dbinfo("confluence", "/opt/atlassian/redradish_confluence/current", "/var/atlassian/application-data/redradish_confluence/current")
	=> #<struct AtlConfig::DBInfo
	 datasource=nil,
	 user="redradish_confluence",
	 password="redradish_confluence",
	 dbtype="postgresql",
	 host="localhost",
	 port=5432,
	 database="redradish_confluence">

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/redradishtech/atl_config.

This is my first public gem, so please be kind!


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
