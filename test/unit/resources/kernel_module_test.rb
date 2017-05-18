# encoding: utf-8
# author: Christoph Hartmann
# author: Dominik Richter

require 'helper'
require 'inspec/resource'

describe 'Inspec::Resources::KernelModule' do
  it 'verify kernel_module parsing' do
    resource = load_resource('kernel_module', 'bridge')
    _(resource.loaded?).must_equal true
  end

  it 'verify kernel_module parsing loaded' do
    resource = load_resource('kernel_module', 'bridges')
    _(resource.loaded?).must_equal false
  end

  it 'verify kernel_module parsing' do
    resource = load_resource('kernel_module', 'bridge')
    _(resource.enabled?).must_equal true
  end

  it 'verify kernel_module parsing' do
    resource = load_resource('kernel_module', 'dhcp')
    _(resource.loaded?).must_equal false
  end

  it 'verify kernel_module parsing disabled' do
    resource = load_resource('kernel_module', 'bridge')
    _(resource.disabled?).must_equal false
  end

  it 'verify kernel_module parsing disabled' do
    resource = load_resource('kernel_module', 'bridges')
    _(resource.disabled?).must_equal true
  end

  it 'verify kernel_module disabled via /bin/true' do
    resource = load_resource('kernel_module', 'floppy')
    _(resource.disabled_via_bin_true?).must_equal false
  end

  it 'verify kernel_module disabled via /bin/false' do
    resource = load_resource('kernel_module', 'floppy')
    _(resource.disabled_via_bin_false?).must_equal false
  end

  it 'verify kernel_module version' do
    resource = load_resource('kernel_module', 'dhcp')
    _(resource.version).must_equal '3.2.2'
  end

  it 'verify kernel_module blacklisting' do
    resource = load_resource('kernel_module', 'floppy')
    _(resource.blacklisted?).must_equal true
  end
end