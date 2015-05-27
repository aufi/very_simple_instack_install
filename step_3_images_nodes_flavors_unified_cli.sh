# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/basic_deployment/basic_deployment.html
# unified CLI alternative
su - stack

source stackrc

export NODE_DIST=rhel7

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150203.1/images/rhel-guest-image-7.1-20150203.1.x86_64.qcow2

export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150203.1.x86_64.qcow2
export RUN_RHOS_RELEASE=1

openstack overcloud image build --all # If this fails and you are on RHEL this should work: openstack overcloud image build --all --run-rhos-release
openstack overcloud image upload # If this fails use the old name: openstack overcloud image create

openstack baremetal import --json ~/instackenv.json
openstack baremetal introspection bulk start

# If the above command doesn't wait for introspection to finish, use this:
watch openstack baremetal introspection bulk status

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 baremetal
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" baremetal

echo "  Next step is overcloud deploy..."
