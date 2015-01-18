Facter.add(:virtualbox_extpack_version) do
  vboxmanage = '/usr/bin/VBoxManage'
  setcode do
    if File.exist? vboxmanage
      output = Facter::Core::Execution.exec("#{vboxmanage} list extpacks")
      version  = output[/Pack no. [0-9]+: +Oracle VM VirtualBox Extension Pack\nVersion: +([^r]+)\nRevision: +([^r]+)\nEdition: +.*/, 1]
      revision = output[/Pack no. [0-9]+: +Oracle VM VirtualBox Extension Pack\nVersion: +([^r]+)\nRevision: +([^r]+)\nEdition: +.*/, 2]

      if (version and revision)
        "#{version}r#{revision}"
      end
    end
  end
end
