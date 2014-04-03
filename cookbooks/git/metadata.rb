name              'git'
maintainer        'Modified'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs git and/or sets up a Git server daemon'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '4.0.0'
recipe            'git', 'Installs git'

%w{ amazon arch centos debian fedora redhat scientific oracle amazon ubuntu windows }.each do |os|
  supports os
end

supports 'mac_os_x', '>= 10.6.0'


