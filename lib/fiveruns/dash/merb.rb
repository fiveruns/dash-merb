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
    
    def self.view_name(obj, args)
      thing, opts = _parse_render_args(obj, args)
      if opts[:template]
        File.basename(opts[:template].to_s)
      elsif thing.is_a?(Symbol)
        thing.to_s
      elsif thing.is_a?(String)
        '(string)'
      end
    rescue => e
      Fiveruns::Dash.logger.debug "FiveRuns Dash could not determine view name  (#{e.message})"
    end
    
    def self._parse_render_args(obj, args)
      thing = args[0]
      opts = args[1] || {}
      # render :format => :xml means render nil, :format => :xml
      opts, thing = thing, nil if thing.is_a?(Hash)

      # Merge with class level default render options
      opts = obj.class.default_render_options.merge(opts)

      # If you don't specify a thing to render, assume they want to render the current action
      thing ||= obj.action_name.to_sym
      [thing, opts]
    end
      
  end
end