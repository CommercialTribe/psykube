require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::Pod
  include Psykube::Kubernetes::Resource
  definition("extensions/v1beta1", "Pod", {
    spec:   {type: Spec},
    status: {type: Status, nilable: true, clean: true, setter: false},
  })
end

require "./pod/*"
