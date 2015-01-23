name             "cookbook_rackbox"
maintainer       "Fred Thompson"
maintainer_email "fred.thompson@buildempire.co.uk"
license          "Apache License 2.0"
description      "Setup a rack-based application server to run unicorn and passenger apps."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "cookbook_rackbox", "run all recipes."
recipe "cookbook_rackbox::ruby", "setup a ruby version manager `rbenv`."
recipe "cookbook_rackbox::nginx", "setup `nginx` as front-end server."
recipe "cookbook_rackbox::unicorn", "setup `unicorn` apps, if any."
recipe "cookbook_rackbox::passenger", "setup `passenger` apps, if any."

supports 'ubuntu'
supports 'debian'

depends 'appbox'
depends 'rbenv'
depends 'nginx'
depends 'unicorn', ">= 1.2.2"
depends 'runit', '>= 1.1.2'
