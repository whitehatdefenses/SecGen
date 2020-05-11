#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_hackerbot_config_generator.rb'

class IDS < HackerbotConfigGenerator

  attr_accessor :labtainers_ip
  attr_accessor :hackerbot_server_ip

  def initialize
    super
    self.module_name = 'Hackerbot Config Generator'
    self.title = 'HBG'

    self.local_dir = File.expand_path('../../',__FILE__)
    self.templates_path = "#{self.local_dir}/templates/"
    self.config_template_path = "#{self.local_dir}/templates/lab.xml.erb"
    self.html_template_path = "#{self.local_dir}/templates/labsheet.html.erb"

    self.labtainers_ip = []
    self.hackerbot_server_ip = []
  end

  def get_options_array
    super + [['--labtainers_ip', GetoptLong::REQUIRED_ARGUMENT],
             ['--hackerbot_server_ip', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--labtainers_ip'
        self.labtainers_ip << arg;
      when '--hackerbot_server_ip'
        self.ids_server_ip << arg;
    end
  end

end

IDS.new.run
