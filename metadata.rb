name             'ilo'
maintainer       'Hewlett Packard Enterprise'
maintainer_email 'chef-cookbooks@groups.ext.hpe.com'
license          'Apache v2.0'
description      'Configure HPE iLO'
long_description 'Configure HPE iLO using the iLO APIs.'
version          '1.2.0'

source_url       'https://github.com/HewlettPackard/ilo-chef'
issues_url       'https://github.com/HewlettPackard/ilo-chef/issues'

chef_version     '>= 12' if respond_to?(:chef_version)

supports         'windows'
supports         'mac_os_x'
supports         'debian'
supports         'ubuntu'
supports         'centos'
supports         'redhat'
supports         'fedora'
supports         'freebsd'
supports         'amazon'
supports         'scientific'
supports         'arch'
supports         'suse'
supports         'xenserver'
supports         'smartos'
supports         'oracle'

depends          'compat_resource'
gem              'ilo-sdk' if respond_to?(:gem)
