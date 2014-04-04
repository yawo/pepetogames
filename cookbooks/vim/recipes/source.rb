#
# Cookbook Name:: vim
# Recipe:: source
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

cache_path            = Chef::Config['file_cache_path']
source_version        = node['vim']['source']['version']

node['vim']['source']['dependencies'].each do |dependency|
  package dependency do
    action :install
  end
end

remote_file "#{cache_path}/vim-#{source_version}.tar.bz2" do
  source "http://ftp.vim.org/pub/vim/unix/vim-#{source_version}.tar.bz2"
  checksum node['vim']['source']['checksum']
  notifies :run, "bash[install_vim]", :immediately
end

bash "install_vim" do
  cwd cache_path
  code <<-EOH
    mkdir vim-#{source_version}
    tar -jxf vim-#{source_version}.tar.bz2 -C vim-#{source_version} --strip-components 1
    (cd vim-#{source_version}/ && ./configure #{node['vim']['source']['configuration']} && make && make install)
  EOH
  action :nothing
end

cookbook_file ".vimrc" do
    path "/home/vagrant/.vimrc"
    action :create
end

bash "pathogen plugins" do
  code <<-EOH
    mkdir -p ~/.vim/autoload ~/.vim/bundle;
    curl -Sso ~/.vim/autoload/pathogen.vim  https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node
    git clone https://github.com/walm/jshint.vim.git  ~/.vim/bundle/node
    git clone https://github.com/marijnh/tern_for_vim.git  ~/.vim/bundle/node
    cd ~/.vim/bundle/node/tern_for_vim
    npm install 
    git clone https://github.com/tpope/vim-surround.git  ~/.vim/bundle/node
    git clone https://github.com/tomtom/tcomment_vim.git  ~/.vim/bundle/node
    git clone ihttps://github.com/guileen/vim-node-dict.git ~/.vim
    cd ~/.vim/vim-node-dict
    chmod a+rwx makenodedict
    git clone https://github.com/ahayman/vim-nodejs-complete.git ~/.vim/
    ./makenodedict /usr/bin/nodejs
  EOH
end
