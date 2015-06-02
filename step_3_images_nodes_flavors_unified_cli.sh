# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/basic_deployment/basic_deployment.html
# unified CLI alternative
su - stack

source stackrc

export NODE_DIST=rhel7

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150203.1/images/rhel-guest-image-7.1-20150203.1.x86_64.qcow2
export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150203.1.x86_64.qcow2
# Enable RHOS
export USE_DELOREAN_TRUNK=0
export RHOS=1
export DIB_YUM_REPO_CONF="/etc/yum.repos.d/rhos-release-7-director-rhel-7.1.repo /etc/yum.repos.d/rhos-release-7-rhel-7.1.repo"

# If this fails and you are on RHEL this should work:
#   openstack overcloud image build --all --run-rhos-release
# This is merged but may not be packaged.
openstack overcloud image build --all

# If this fails, the package doesn't have the fix yet. Use:
#   openstack overcloud image create
openstack overcloud image upload

openstack baremetal import --json ~/instackenv.json
openstack baremetal configure boot

# If this command doesn't wait for introspection to finish. Use watch to wait
# for it to finish before continuing.
#    watch openstack baremetal introspection bulk status
openstack baremetal introspection bulk start

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 baremetal
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" baremetal

# -- Now we are ready to deploy!

# Pick one of the following. Then between deploys use heat stack-list and heat
# stack-delete to find the ID and delete the stack if you want to try both of
# these.

# THT ONLY

openstack overcloud deploy --use-tripleo-heat-templates

# WITH TUSKAR

# Get the plan ID with
openstack management plan list

# This will fail, so the --debug flag is handy
openstack overcloud deploy --plan-uuid $ID --debug

# Perform post config
# This needs to be replaced with 'openstack overcloud endpoint show'
OVERCLOUD_ENDPOINT=$(heat output-show overcloud KeystoneURL|sed 's/^"\(.*\)"$/\1/')
export OVERCLOUD_IP=$(echo $OVERCLOUD_ENDPOINT | awk -F '[/:]' '{print $4}')
source overcloudrc
openstack overcloud postconfig $OVERCLOUD_IP
