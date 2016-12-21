Facter.add(:virtualbox_version) do
  vboxmanage = '/usr/bin/VBoxManage'
  setcode do
    `#{vboxmanage} --version`.strip if File.exist? vboxmanage
  end
end
