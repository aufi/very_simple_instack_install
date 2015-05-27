# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/basic_deployment/basic_deployment.html
# unified CLI alternative
su - stack

source stackrc

export NODE_DIST=rhel7

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150203.1/images/rhel-guest-image-7.1-20150203.1.x86_64.qcow2

export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150203.1.x86_64.qcow2
export RUN_RHOS_RELEASE=1

# If this fails and you are on RHEL this should work:
#   openstack overcloud image build --all --run-rhos-release
# This is merged but may not be packaged.
openstack overcloud image build --all

# If this fails, the package doesn't have the fix yet. Use:
#   openstack overcloud image create
openstack overcloud image upload

openstack baremetal import --json ~/instackenv.json

# If this command doesn't wait for introspection to finish. Use watch to wait
# for it to finish before continuing.
#    watch openstack baremetal introspection bulk status
openstack baremetal introspection bulk start

openstack baremetal configure boot

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 baremetal
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" baremetal

# -- Now we are ready to deploy!

# Something doesn't seem to be setup correctly.
# openstack server list
# openstack server show $ID (picking an from above that is in ERROR state)
openstack overcloud deploy --use-tripleo-heat-templates
