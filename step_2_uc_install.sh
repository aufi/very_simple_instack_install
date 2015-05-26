# https://repos.fedorapeople.org/repos/openstack-m/instack-undercloud/internal-html/install-undercloud.html
su - stack

# different to instack docs, moved up here by maufart, Enable RDO-Manager Trunk
sudo curl -o /etc/yum.repos.d/rdo-management-trunk.repo http://trunk-mgt.rdoproject.org/centos-kilo/current-passed-ci/delorean-rdo-management.repo

sudo yum install -y http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm
sudo rhos-release 6

# We need openwsman-python from the optional repo
sudo yum install -y yum-utils
sudo yum-config-manager --enable rhelosp-rhel-7-server-opt

# Enable RDO Kilo
sudo yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm

sudo yum install -y python-rdomanager-oscplugin

openstack undercloud install

sudo cp /root/tripleo-undercloud-passwords .
sudo chown $USER: tripleo-undercloud-passwords
sudo cp /root/stackrc .
sudo chown $USER: stackrc