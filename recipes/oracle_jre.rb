#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: java
# Recipe:: oracle
#
# Copyright 2011, Bryan w. Berry
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


java_home = node['java']["java_home"]
arch = node['java']['arch']
jre_version = node['java']['jre_version']

#convert version number to a string if it isn't already
if jre_version.instance_of? Fixnum
  jre_version = jre_version.to_s
end

case jre_version
when "6"
  tarball_url = node['java']['jre']['6'][arch]['url']
  tarball_checksum = node['java']['jre']['6'][arch]['checksum']
  bin_cmds = node['java']['jre']['6']['bin_cmds']
when "7"
  tarball_url = node['java']['jre']['7'][arch]['url']
  tarball_checksum = node['java']['jre']['7'][arch]['checksum']
  bin_cmds = node['java']['jre']['7']['bin_cmds']
end

if tarball_url =~ /example.com/
  Chef::Application.fatal!("You must change the download link to your private repository. You can no longer download java directly from http://download.oracle.com without a web broswer")
end

ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
end

file "/etc/profile.d/jre.sh" do
  content <<-EOS
    export JAVA_HOME=#{node['java']['java_home']}
  EOS
  mode 0755
end


java_ark "jre" do
  url tarball_url
  checksum tarball_checksum
  app_home java_home
  bin_cmds bin_cmds
  alternatives_priority 1062
  action :install
end
