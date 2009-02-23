Fiveruns::Dash.register_recipe :merb, :url => 'http://dash.fiveruns.com' do |recipe|
  
  recipe.time :response_time, :method => 'Merb::Request#dispatch_action',
                              :context => lambda { |request, *args|
                                Fiveruns::Dash::Context.set [
                                  :action,
                                  "#{request.controller}##{request.params[:action]}"
                                ]
                                Fiveruns::Dash.logger.info "Setting response_time action context to #{Fiveruns::Dash::Context.context.inspect}"
                                
                                [[], Fiveruns::Dash::Context.context]
                              }
  
  recipe.counter :requests, :incremented_by => 'Merb::Request#dispatch_action',
                            :context => lambda { |request, *args|
                              Fiveruns::Dash::Context.set [
                                :action,
                                "#{request.controller}##{request.params[:action]}"
                              ]
                              Fiveruns::Dash.logger.info "Setting requests action context to #{Fiveruns::Dash::Context.context.inspect}"
                              
                              [[], Fiveruns::Dash::Context.context]
                            }
  
  recipe.time :render_time, :method => 'Merb::RenderMixin#render',
                            :reentrant => true,
                            :context => lambda { |obj, *args|
                              name = Fiveruns::Dash::Merb.view_name(obj, args)
                              if name
                                context = Fiveruns::Dash::Context.context.dup
                                context.push(:view, name)
                                Fiveruns::Dash.logger.info "Setting view context to #{context.inspect}"
                                [[], context]
                              else
                                Fiveruns::Dash.logger.info "Setting view context to empty #{[obj, args].inspect}"
                                []
                              end
                            }
  
  # ==============
  # = EXCEPTIONS =
  # ==============
  
  merb_exceptions = Merb::ControllerExceptions.constants.map do |name|
    "Merb::ControllerExceptions::#{name}"
  end
  recipe.ignore_exceptions do |ex|
    merb_exceptions.include?(ex.class.name)
  end
  recipe.add_exceptions_from 'Merb::Request#dispatch_action' do |ex, request|
    info = {:name => "#{ex.class.name} in #{request.controller}##{request.params[:action]}"}
    # TODO: We shouldn't need to double-serialize to_json -- BW
    begin
      info[:params] = request.params.to_json
    rescue
      Merb.logger.warn "Could not capture request params for exception"
    end
    begin
      info[:environment] = request.env.to_json
    rescue
      Merb.logger.warn "Could not capture request env for exception"
    end
    # TODO: capture session
    # TODO: capture headers
    info
  end
  
end