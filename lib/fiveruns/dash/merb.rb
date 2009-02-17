require 'fiveruns/dash/merb/recipe'

module Fiveruns::Dash
  module Merb
    
    def self.start
      ::Fiveruns::Dash.logger.info "Starting FiveRuns Dash"
      Fiveruns::Dash.start(:app => ::Merb::Config[:dash][:token]) do |config|
        Array(::Merb::Config[:dash][:recipes]).each do |set|
          name, url = Array(set)
          ::Fiveruns::Dash.logger.debug "Adding FiveRuns Dash recipe: #{set.inspect}"
          config.add_recipe(name, :url => url)
        end
      end
    end
      
  end
end