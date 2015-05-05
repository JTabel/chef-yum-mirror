require 'spec_helper'

%w(centos).each do
  describe 'yum-mirror::default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['yum-mirror']['mirrors'] = %w(centos6 centos7)
      end.converge(described_recipe)
    end
    before do
      stub_data_bag('yum-mirror').and_return(%w(centos7 centos6))
      stub_data_bag_item('yum-mirror', 'centos6').and_return(
      {
        id: 'centos6',
        mirrorlists: {
          base: 'http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=os',
          extras: 'http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=extras'
        },
        gpg: 'http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6'
      }
      )
      stub_data_bag_item('yum-mirror', 'centos7').and_return(
      {
        id: 'centos7',
        mirrorlists: {
          base: 'http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os',
          extras: 'http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=extras'
        },
        gpg: 'http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7'
      }
      )
    end

    %w(yum-utils createrepo).each do |package|
      it "installs #{package}" do
        expect(chef_run).to install_package(package)
      end
    end

    it 'should create data directory for mirror' do
      expect(chef_run).to create_directory('/var/local/mirror')
    end

    %w(centos6 centos7).each do |release|
      it "should create a directory for #{release}" do
        expect(chef_run).to create_directory("/var/local/mirror/#{release}")
      end

      %w(base extras).each do |repo|
        it "should create a directory for #{repo}" do
          expect(chef_run).to create_directory("/var/local/mirror/#{release}/#{release}-#{repo}")
        end

        it "should create a yum repo for #{repo}" do
          expect(chef_run).to create_yum_repository("#{release}-#{repo}-mirror").with(repositoryid: "#{release}-#{repo}")
        end
      end
    end

    it 'should create a cron script for the repo sync' do
      expect(chef_run).to create_template('/var/local/mirror/sync-repos.sh').with(
        user: 'root',
        group: 'root',
        mode: '0700'
      )
    end

    it 'should create the cron for the repo sync' do
      expect(chef_run).to create_cron('sync-repos').with(
        minute: '0',
        hour: '*/4',
        command: '/var/local/mirror/sync-repos.sh'
      )
    end
  end
end
