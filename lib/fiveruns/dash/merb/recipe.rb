Fiveruns::Dash.register_recipe :merb, :url => 'http://dash.fiveruns.com' do |recipe|
  recipe.time 'response_time', :method => 'Merb::Request#dispatch_action'
  recipe.counter 'requests', :incremented_by => 'Merb::Request#dispatch_action'
  recipe.time 'render_time', :method => 'Merb::RenderMixin#render'
end