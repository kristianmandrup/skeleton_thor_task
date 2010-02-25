require 'thor/group'
require 'skeleton_creator'


class Skeleton < Thor::Group
  include Thor::Actions

  # Define arguments and options
  argument :file_name, :desc => 'The YAML file with the skeleton configuration', :required => true, :type => :string, :banner => 'config_file'
  class_option :root_dirs, :desc => 'The dir where the skeleton is generated', :type => :array, :default => '.', :banner => 'dir1 dir2', :aliases => '-D'        
  class_option :template, :desc => 'Use a template YAML config in ~/.skeletons', :aliases => '-T', :optional => true, :type => :boolean
  class_option :root, :desc => 'Root', :aliases => '-R', :optional => true, :type => :string  
  class_option :fake, :desc => 'Run as simulation', :aliases => '-F', :optional => true, :type => :boolean  
                           
  def generate
    template_file = file_name
    if options[:template]            
      template_file = File.join(ENV['HOME'], '.skeletons', file_name)
    end
    raise "YAML config file '#{template_file}' not found" if !File.exist? template_file
    runner = FileSystem::Runner.new template_file 
    @run_options = {}     
    add_options(:root, :fake)

    root_dirs = options[:root_dirs]    
    runner.run root_dirs, @run_options
  end

protected                                                   
  def add_options(*keys)
    keys.each do |key|
      @run_options.merge!({key => options[key]}) if options[key]  
    end
  end
                         
end