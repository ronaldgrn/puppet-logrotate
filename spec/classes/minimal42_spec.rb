require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'logrotate' do

  let(:title) { 'logrotate' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }
  let(:default_params) { {
    :old_config_dir => '/etc/logrotate.d'
  } }
  let(:params) { default_params }
  describe 'Test minimal installation' do
    it { should contain_package('logrotate').with_ensure('present') }
    it { should contain_file('logrotate.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' }.merge default_params }
    it { should contain_package('logrotate').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true }.merge default_params }
    it 'should remove Package[logrotate]' do should contain_package('logrotate').with_ensure('absent') end 
    it 'should remove logrotate configuration file' do should contain_file('logrotate.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true}.merge default_params }
    it { should contain_package('logrotate').with_noop('true') }
    it { should contain_file('logrotate.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "logrotate/spec.erb" , :options => { 'opt_a' => 'value_a' } }.merge default_params }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'logrotate.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'logrotate.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/logrotate/spec"}.merge default_params }
    it { should contain_file('logrotate.conf').with_source('puppet:///modules/logrotate/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/logrotate/dir/spec" , :source_dir_purge => true }.merge default_params }
    it { should contain_file('logrotate.dir').with_source('puppet:///modules/logrotate/dir/spec') }
    it { should contain_file('logrotate.dir').with_purge('true') }
    it { should contain_file('logrotate.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "logrotate::spec" }.merge default_params }
    it { should contain_file('logrotate.conf').with_content(/rspec.example42.com/) }
  end

end
