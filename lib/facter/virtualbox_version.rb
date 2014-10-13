Facter.add(:virtualbox_version) do
    setcode do
        Facter::Core::Execution.exec('/usr/bin/VBoxManage --version')
    end
end
