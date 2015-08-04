#! /usr/bin/env ruby -S rspec
require 'spec_helper'

# WHAT IS THIS FOR?
#
# I realise that this probably seems a bit pointless.
# The main purpose of these tests is to test all of the
# things that users will rely on, i.e. defaults so that
# if someone changes them it will fail a test.

describe Puppet::Type.type(:virtual_machine) do
  # I'm not totally sure what this is for
  let :virtual_machine do
    Puppet::Type::type(:virtual_machine).new(
      :name => 'foo', 
      :ensure => 'present', 
      :ostype => 'Other')
  end

  it 'should accept valid ostypes' do
    valid_types = ['Other' ,'Other_64' ,'Windows31' ,'Windows95' ,'Windows98' ,
      'WindowsMe' ,'WindowsNT4' ,'Windows2000' ,'WindowsXP' ,'WindowsXP_64' ,
      'Windows2003' ,'Windows2003_64' ,'WindowsVista' ,'WindowsVista_64' ,
      'Windows2008' ,'Windows2008_64' ,'Windows7' ,'Windows7_64' ,'Windows8' ,
      'Windows8_64' ,'Windows81' ,'Windows81_64' ,'Windows2012_64' ,'Windows10' ,
      'Windows10_64' ,'WindowsNT' ,'WindowsNT_64' ,'Linux22' ,'Linux24' ,
      'Linux24_64' ,'Linux26' ,'Linux26_64' ,'ArchLinux' ,'ArchLinux_64' ,
      'Debian' ,'Debian_64' ,'OpenSUSE' ,'OpenSUSE_64' ,'Fedora' ,'Fedora_64' ,
      'Gentoo' ,'Gentoo_64' ,'Mandriva' ,'Mandriva_64' ,'RedHat' ,'RedHat_64' ,
      'Turbolinux' ,'Turbolinux_64' ,'Ubuntu' ,'Ubuntu_64' ,'Xandros' ,
      'Xandros_64' ,'Oracle' ,'Oracle_64' ,'Linux' ,'Linux_64' ,'Solaris' ,
      'Solaris_64' ,'OpenSolaris' ,'OpenSolaris_64' ,'Solaris11_64' ,'FreeBSD' ,
      'FreeBSD_64' ,'OpenBSD' ,'OpenBSD_64' ,'NetBSD' ,'NetBSD_64' ,'OS2Warp3' ,
      'OS2Warp4' ,'OS2Warp45' ,'OS2eCS' ,'OS2' ,'MacOS' ,'MacOS_64' ,'MacOS106' ,
      'MacOS106_64' ,'MacOS107_64' ,'MacOS108_64' ,'MacOS109_64' ,'DOS' ,
      'Netware' ,'L4' ,'QNX' ,'JRockitVE']
    valid_types.each do | type |
      expect {
        Puppet::Type.type(:virtual_machine).new(
          :name   => 'foo',
          :ostype => type)
      }.not_to raise_error
    end    
  end

  it 'should default register to true' do
    expect(virtual_machine[:register]).to eq(:true)
  end

  it 'should accept a boolean for register' do
    virtual_machine[:register] = :false
    expect(virtual_machine[:register]).to eq(:false)
  end

  it 'should defult to state: running' do
    expect(virtual_machine[:state]).to eq(:running)
  end

  it 'should default the description' do
    expect(virtual_machine[:description]).to eq("Managed by Puppet, do not modify settings using the VirtualBox GUI")
  end

  it 'should default the io_apic' do
    expect(virtual_machine[:io_apic]).to eq('on')
  end

  it 'should accept all valid states' do
    states = [:running, :poweroff]
    states.each do |state|
      virtual_machine[:state] = state
      expect(virtual_machine[:state]).to eq(state)
    end
  end

  it 'should reject invalid states' do
    expect {
      Puppet::Type::type(:virtual_machine).new(
        :name => 'foo',
        :state => 'some_invalid_state')
    }.to raise_error
  end
end