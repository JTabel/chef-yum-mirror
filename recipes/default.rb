#
# Cookbook Name:: yum-mirror
# Recipe:: default
#
# Copyright 2015, Bigpoint GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum'

%w(yum-utils createrepo).each do |pkg|
  package pkg do
    action :install
  end
end

directory node['yum-mirror']['repopath'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

repos = []

node['yum-mirror']['mirrors'].each do |db|
  mirror = data_bag_item('yum-mirror', db)

  directory "#{node['yum-mirror']['repopath']}/#{mirror['id']}" do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  mirror['mirrorlists'].each do |repo, url|
    yum_repository "#{mirror['id']}-#{repo}-mirror" do
      repositoryid "#{mirror['id']}-#{repo}"
      description "mirror for #{mirror['id']} - #{repo}"
      mirrorlist url
      gpgkey mirror['gpgkey']
      enabled false
      action :create
    end

    directory "#{node['yum-mirror']['repopath']}/#{mirror['id']}/#{mirror['id']}-#{repo}" do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    repos << repo
  end
end

template '/var/local/mirror/sync-repos.sh' do
  source 'sync-repos.sh.erb'
  owner 'root'
  group 'root'
  mode '0700'
  variables(
    'repo' => repos
  )
end

cron 'sync-repos' do
  minute 0
  hour '*/4'
  user 'root'
  command '/var/local/mirror/sync-repos.sh'
end
