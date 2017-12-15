# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Configure the ansible deploy interface
#
# === Parameters
#
# [*package_ensure*]
#   (optional) The state of the required packages
#   Defaults to 'present'
#
# [*ansible_extra_args*]
#   (optional) Extra arguments to pass on every invocation of ansible.
#   Defaults to $::os_service_default
#
# [*playbooks_path*]
#   (optional) Path to directory with playbooks, roles and local inventory.
#   Defaults to $::os_service_default
#
# [*config_file_path*]
#   (optional) Path to ansible configuration file.
#   Defaults to $::os_service_default
#
# [*image_store_insecure*]
#   (optional) Skip verifying SSL connections to the image store when
#   downloading the image.
#   Defaults to $::os_service_default
#

class ironic::drivers::ansible (
  $package_ensure       = 'present',
  $ansible_extra_args   = $::os_service_default,
  $playbooks_path       = $::os_service_default,
  $config_file_path     = $::os_service_default,
  $image_store_insecure = $::os_service_default,
) {

  include ::ironic::deps
  include ::ironic::params

  # Configure ironic.conf
  ironic_config {
    'ansible/ansible_extra_args':   value => $ansible_extra_args;
    'ansible/playbooks_path':       value => $playbooks_path;
    'ansible/config_file_path':     value => $config_file_path;
    'ansible/image_store_insecure': value => $image_store_insecure;
  }

  ensure_packages('ansible',
    {
      ensure => $package_ensure,
      tag    => ['openstack', 'ironic-package'],
    }
  )

  ensure_packages('systemd-python',
    {
      ensure => $package_ensure,
      name   => $::ironic::params::systemd_python_package,
      tag    => ['openstack', 'ironic-package'],
    }
  )

}