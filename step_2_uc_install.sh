#http://repos.fedorapeople.org/repos/openstack-m/instack-undercloud/internal-html/install-undercloud.html
su - stack

sudo rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm

# Enable either poodles or puddles:
# To enable poodles:
sudo rhos-release 7-director -d
# To enable puddles:
sudo rhos-release 7-director

# We need openwsman-python from the optional repo
sudo yum install -y yum-utils
sudo yum-config-manager --enable rhelosp-rhel-7-server-opt

# Enable RDO Kilo
sudo yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm

# Enable RDO-Manager Trunk
sudo curl -o /etc/yum.repos.d/rdo-management-trunk.repo http://trunk-mgt.rdoproject.org/centos-kilo/current-passed-ci/delorean-rdo-management.repo

sudo yum install -y python-rdomanager-oscplugin

openstack undercloud install

# Is it needed?
# sudo cp /root/tripleo-undercloud-passwords .
# sudo chown $USER: tripleo-undercloud-passwords
# sudo cp /root/stackrc .
# sudo chown $USER: stackrcudo chown $USER: stackrc

