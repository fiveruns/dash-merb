Fiveruns::Dash.register_recipe :merb, :url => 'http://dash.fiveruns.com' do |recipe|
  recipe.time :response_time, :method => 'Merb::Request#dispatch_action'
  recipe.counter :requests, :incremented_by => 'Merb::Request#dispatch_action'
  recipe.time :render_time, :method => 'Merb::RenderMixin#render'
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