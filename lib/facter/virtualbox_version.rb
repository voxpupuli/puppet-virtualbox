Facter.add(:virtualbox_version) do
  vboxmanage = '/usr/bin/VBoxManage'
  setcode do
    if File.exist? vboxmanage
      %x{#{vboxmanage} --version}
    end
  end
end
