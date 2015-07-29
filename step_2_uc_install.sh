# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/installation/installing.html
su - stack

sudo rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm

# Enable either poodles or puddles:
# To enable poodles: CHOOSE
# sudo rhos-release 7-director -d
# To enable puddles:
sudo rhos-release 7-director

# Install the RDO Manager CLI
sudo yum install -y python-rdomanager-oscplugin

openstack undercloud install

