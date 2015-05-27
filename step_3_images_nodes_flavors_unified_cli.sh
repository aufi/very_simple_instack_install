# https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/basic_deployment/basic_deployment.html
# unified CLI alternative
su - stack

source stackrc

export NODE_DIST=rhel7

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150203.1/images/rhel-guest-image-7.1-20150203.1.x86_64.qcow2

export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150203.1.x86_64.qcow2
export RUN_RHOS_RELEASE=1

openstack overcloud image build --all # TODO: does not work now - Should be fixed
openstack overcloud image upload # updated, previous was create

openstack baremetal import --json ~/instackenv.json
openstack baremetal introspection bulk start # TODO: doesn't wait for introspection to finish - fix merged

# Use this until the above is fixed, then they are all finished. - Fix merged
# watch openstack baremetal introspection bulk status

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 baremetal
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" baremetal

echo "  Next step is overcloud deploy..."
