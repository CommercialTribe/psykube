require "./concerns/*"

abstract class Psykube::Generator
  class ReplicationController < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result(manifest : Manifest::V1)
      Pyrite::Api::Core::V1::ReplicationController.new(
        metadata: generate_metadata,
        spec: Pyrite::Api::Core::V1::ReplicationControllerSpec.new(
          selector: generate_selector.match_labels,
          replicas: manifest.replicas,
          template: generate_pod_template
        )
      )
    end
  end
end
