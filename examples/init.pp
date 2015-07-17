# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#include virtualbox

virtual_machine { 'computer':
  ensure          => present,
  ostype          => 'Other',
  register        => true,
  state           => 'running',
  description     => 'Managed by puppet',
  memory          => 512,
  pagefusion      => 'off',
  vram            => 16,
  acpi            => 'on',
  nestedpaging    => 'on',
  largepages      => 'on',
  longmode        => 'off',
  synthcpu        => 'off',
  hardwareuuid    => '3e039b44-0b67-4109-8936-f9e3ac519c9b',
  cpus            => 2,
  cpuexecutioncap => 100,
  monitorcount    => 3,
  accelerate3d    => 'off',
  firmware        => 'BIOS',
  boot1           => 'net',
  boot2           => 'dvd',
  boot3           => 'disk',
  boot4           => 'none',
  io_apic         => 'on',
  nics            => {
    1 => {
      'mode'  => 'nat',
      'type'  => 'Am79C973',
      'speed' => 0
    },
    2 => {
      'mode'          => 'bridged',
      'type'          => 'Am79C973',
      'speed'         => 0,
      'bridgeadapter' => 'en0: Wi-Fi (AirPort)',
    }
  }
}