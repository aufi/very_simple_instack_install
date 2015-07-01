# https://repos.fedorapeople.org/repos/openstack-m/instack-undercloud/internal-html/virt-setup.html
sudo useradd stack
echo "stack" | sudo passwd stack --stdin
echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
sudo chmod 0440 /etc/sudoers.d/stack

su - stack

sudo rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm

# Enable either poodles or puddles:
# To enable poodles: CHOOSE
sudo rhos-release 7-director -d
# To enable puddles:
#sudo rhos-release 7-director

# We need openwsman-python from the optional repo
sudo yum install -y yum-utils
sudo yum-config-manager --enable rhelosp-rhel-7-server-opt

# Enable extra packages
sudo yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Enable RDO Kilo
sudo yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm

# Enable RDO-Manager Trunk
sudo curl -o /etc/yum.repos.d/rdo-management-trunk.repo http://trunk-mgt.rdoproject.org/centos-kilo/current-passed-ci/delorean-rdo-management.repo

sudo yum install -y instack-undercloud

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150224.0/images/rhel-guest-image-7.1-20150224.0.x86_64.qcow2
export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150224.0.x86_64.qcow2
export DIB_YUM_REPO_CONF="/etc/yum.repos.d/rhos-release-7-director-rhel-7.1.repo /etc/yum.repos.d/rhos-release-7-rhel-7.1.repo"

instack-virt-setup

sudo virsh list --all
