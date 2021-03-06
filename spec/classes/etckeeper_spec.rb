require 'spec_helper'

describe 'etckeeper' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context "managing the VCS package", :compile do
        it { should contain_class('etckeeper') }
        it { should contain_class('etckeeper::config') }
        it { should contain_class('etckeeper::install') }
        it { should contain_class('etckeeper::params') }
        it { should contain_exec('etckeeper init') }
        it { should contain_file('/etc/_darcs').with_ensure('absent') }
        it { should contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { should contain_file('/etc/.hg').with_ensure('absent') }
        it { should contain_file('/etc/.hgignore').with_ensure('absent') }
        it { should contain_file('/etc/etckeeper') }
        it { should contain_file('/etc/etckeeper/etckeeper.conf') }
        it { should contain_package('etckeeper') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystem]
          when 'Ubuntu'
            case facts[:operatingsystemrelease]
            when '14.04'
              it { should contain_file('/etc/.git').with_ensure('absent') }
              it { should contain_file('/etc/.gitignore').with_ensure('absent') }
              it { should contain_package('bzr') }
              it { should_not contain_package('darcs') }
              it { should_not contain_package('git') }
              it { should_not contain_package('hg') }
            else
              it { should contain_file('/etc/.bzr').with_ensure('absent') }
              it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
              it { should_not contain_package('bzr') }
              it { should_not contain_package('darcs') }
              it { should contain_package('git') }
              it { should_not contain_package('hg') }
            end
          else
            it { should contain_file('/etc/.bzr').with_ensure('absent') }
            it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
            it { should_not contain_package('bzr') }
            it { should_not contain_package('darcs') }
            it { should contain_package('git') }
            it { should_not contain_package('hg') }
          end
        else
          it { should contain_file('/etc/.bzr').with_ensure('absent') }
          it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
          it { should_not contain_package('bzr') }
          it { should_not contain_package('darcs') }
          it { should contain_package('git') }
          it { should_not contain_package('hg') }
        end
      end

      context "not managing the VCS package", :compile do
        let(:params) do
          {
            :manage_vcs_package => false,
          }
        end

        it { should contain_class('etckeeper') }
        it { should contain_class('etckeeper::config') }
        it { should contain_class('etckeeper::install') }
        it { should contain_class('etckeeper::params') }
        it { should contain_exec('etckeeper init') }
        it { should contain_file('/etc/_darcs').with_ensure('absent') }
        it { should contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { should contain_file('/etc/.hg').with_ensure('absent') }
        it { should contain_file('/etc/.hgignore').with_ensure('absent') }
        it { should contain_file('/etc/etckeeper') }
        it { should contain_file('/etc/etckeeper/etckeeper.conf') }
        it { should_not contain_package('bzr') }
        it { should contain_package('etckeeper') }
        it { should_not contain_package('git') }
        it { should_not contain_package('darcs') }
        it { should_not contain_package('hg') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystem]
          when 'Ubuntu'
            case facts[:operatingsystemrelease]
            when '14.04'
              it { should contain_file('/etc/.git').with_ensure('absent') }
              it { should contain_file('/etc/.gitignore').with_ensure('absent') }
            else
              it { should contain_file('/etc/.bzr').with_ensure('absent') }
              it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
            end
          else
            it { should contain_file('/etc/.bzr').with_ensure('absent') }
            it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
          end
        else
          it { should contain_file('/etc/.bzr').with_ensure('absent') }
          it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
        end
      end

      context "forcing the user name & email", :compile do
        let(:params) do
          {
            :vcs_user_name  => 'Alice',
            :vcs_user_email => 'alice@example.com',
          }
        end

        it { should contain_class('etckeeper') }
        it { should contain_class('etckeeper::config') }
        it { should contain_class('etckeeper::install') }
        it { should contain_class('etckeeper::params') }
        it { should contain_exec('etckeeper init') }
        it { should contain_file('/etc/_darcs').with_ensure('absent') }
        it { should contain_file('/etc/.darcsignore').with_ensure('absent') }
        it { should contain_file('/etc/.hg').with_ensure('absent') }
        it { should contain_file('/etc/.hgignore').with_ensure('absent') }
        it { should contain_file('/etc/etckeeper') }
        it { should contain_file('/etc/etckeeper/etckeeper.conf') }
        it { should contain_package('etckeeper') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystem]
          when 'Ubuntu'
            case facts[:operatingsystemrelease]
            when '14.04'
              it { should contain_file('/etc/.git').with_ensure('absent') }
              it { should contain_file('/etc/.gitignore').with_ensure('absent') }
              it { should contain_package('bzr') }
              it { should_not contain_package('darcs') }
              it { should_not contain_package('git') }
              it { should_not contain_package('hg') }
            else
              it { should contain_file('/etc/.bzr').with_ensure('absent') }
              it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
              it { should contain_file('/etc/.git/config') }
              it { should contain_ini_setting('/etc/.git/config user.email') }
              it { should contain_ini_setting('/etc/.git/config user.name') }
              it { should_not contain_package('bzr') }
              it { should_not contain_package('darcs') }
              it { should contain_package('git') }
              it { should_not contain_package('hg') }
            end
          else
            it { should contain_file('/etc/.bzr').with_ensure('absent') }
            it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
            it { should contain_file('/etc/.git/config') }
            it { should contain_ini_setting('/etc/.git/config user.email') }
            it { should contain_ini_setting('/etc/.git/config user.name') }
            it { should_not contain_package('bzr') }
            it { should_not contain_package('darcs') }
            it { should contain_package('git') }
            it { should_not contain_package('hg') }
          end
        else
          it { should contain_file('/etc/.bzr').with_ensure('absent') }
          it { should contain_file('/etc/.bzrignore').with_ensure('absent') }
          it { should contain_file('/etc/.git/config') }
          it { should contain_ini_setting('/etc/.git/config user.email') }
          it { should contain_ini_setting('/etc/.git/config user.name') }
          it { should_not contain_package('bzr') }
          it { should_not contain_package('darcs') }
          it { should contain_package('git') }
          it { should_not contain_package('hg') }
        end
      end
    end
  end
end
