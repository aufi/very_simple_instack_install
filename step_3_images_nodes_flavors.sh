#https://repos.fedorapeople.org/repos/openstack-m/docs/internal/master/basic_deployment/basic_deployment.html
su - stack

source stackrc

export NODE_DIST=rhel7

curl -O http://download.devel.redhat.com/brewroot/packages/rhel-guest-image/7.1/20150203.1/images/rhel-guest-image-7.1-20150203.1.x86_64.qcow2

export DIB_LOCAL_IMAGE=rhel-guest-image-7.1-20150203.1.x86_64.qcow2
export RUN_RHOS_RELEASE=1

instack-build-images
instack-prepare-for-overcloud

instack-ironic-deployment --nodes-json instackenv.json --register-nodes
instack-ironic-deployment --discover-nodes
instack-ironic-deployment --setup-flavors

echo "  Next step is overcloud deploy..."