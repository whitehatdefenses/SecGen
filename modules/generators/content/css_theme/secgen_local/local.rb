#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_encoder.rb'
require 'faker'

class CSSFileSelector < StringEncoder

  def initialize
    super
    self.module_name = 'CSS File Selector'
  end

  # This utilises from the Website_theme generator
  def encode_all
    # TODO: FIXME: shouldn't be reading from this module directory directly
    filenames = Dir.entries("#{ROOT_DIR}/modules/vulnerabilities/unix/webapp/commando/files/css_themes/").reject {|f| File.directory?(f) || f[0].include?('.')}
    self.outputs << filenames.sample
  end

end

CSSFileSelector.new.run
