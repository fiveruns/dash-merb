require 'fiveruns/dash/merb/recipe'

module Fiveruns::Dash
  module Merb
    
    def self.start
      ::Fiveruns::Dash.logger.info "Starting FiveRuns Dash"
      Fiveruns::Dash.start(:app => ::Merb::Config[:dash][:token]) do |config|
        Array(::Merb::Config[:dash][:recipes]).each do |set|
          name, options = Array(set)
          ::Fiveruns::Dash.logger.debug "Adding FiveRuns Dash recipe: #{set.inspect}"
          config.add_recipe(name, options)
        end
      end
    end
    
    def self.autoadd_orm
      return if !::Merb.orm || !::Merb::Config[:dash][:autoadd_orm]
      require "fiveruns-dash-#{::Merb.orm}"
      ::Merb::Config[:dash][:recipes].push([
        ::Merb.orm,
        {
          :url => 'http://dash.fiveruns.com',
          :total_time => 'response_time'
        }
      ])
      Fiveruns::Dash.logger.info "Auto-added recipe for ORM from fiveruns-dash-#{::Merb.orm}"
    rescue LoadError
      Fiveruns::Dash.logger.warn "Could not auto-add recipe for ORM from fiveruns-dash-#{::Merb.orm}"
    end
      
  end
end