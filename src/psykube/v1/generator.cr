require "openssl"
require "file_utils"
require "crustache"
require "./manifest"
require "./generator/concerns/*"
require "./generator/*"

abstract class Psykube::V1::Generator
  class ValidationError < Exception; end

  alias TemplateData = Hash(String, String)

  include Concerns::MetadataHelper

  @actor : Actor
  getter manifest : Manifest

  delegate name, cluster, tag, digest, namespace, cluster_name, to: @actor
  delegate lookup_port, to: manifest

  def self.result(*args, **params)
    new(*args, **params).result
  end

  def initialize(generator : Generator)
    @manifest = generator.@manifest
    @actor = generator.@actor
  end

  def initialize(@manifest : Manifest, @actor : Actor) ; end

  def to_yaml(*args, **props)
    result.to_yaml(*args, **props)
  end

  def to_json(*args, **props)
    result.to_json(*args, **props)
  end

  abstract def result

  private def cluster_config_map
    manifest.config_map.merge cluster.config_map
  end

  private def cluster_secrets
    manifest.secrets.merge cluster.secrets
  end

  private def manifest_env
    manifest.env || {} of String => String | Manifest::Env
  end
end