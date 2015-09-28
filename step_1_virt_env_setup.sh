# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/environments/virtual.html
sudo useradd stack
echo "stack" | sudo passwd stack --stdin
echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
sudo chmod 0440 /etc/sudoers.d/stack

su - stack

sudo rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm

# Enable either poodles or puddles:
# To enable poodles: CHOOSE
# sudo rhos-release 7-director -d
# To enable puddles:
sudo rhos-release 7-director

# We need openwsman-python from the optional repo
sudo yum install -y yum-utils
sudo yum-config-manager --enable rhelosp-rhel-7-server-opt

# Enable extra packages
#sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Enable RDO Kilo
#sudo yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm

# Enable RDO-Manager Trunk
#sudo curl -o /etc/yum.repos.d/rdo-management-trunk.repo http://trunk-mgt.rdoproject.org/centos-kilo/current-passed-ci/delorean-rdo-management.repo

sudo yum install -y instack-undercloud

IMAGE=http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150224.0/images/rhel-guest-image-7.1-20150224.0.x86_64.qcow2
curl -I $IMAGE  # get headers to ensure connection
curl -O $IMAGE
export DIB_LOCAL_IMAGE=`basename $IMAGE`
export DIB_YUM_REPO_CONF="/etc/yum.repos.d/rhos-release-7-director-rhel-7.1.repo /etc/yum.repos.d/rhos-release-7-rhel-7.1.repo"

# additional setup, e.g. export NODE_COUNT=3 for ceph 
# For network isolation:
# export NODE_COUNT=9
# export TESTENV_ARGS="--baremetal-bridge-names 'brbm' --vlan-trunk-ids='10 20 30 40 50'"

instack-virt-setup

sudo virsh list --all
