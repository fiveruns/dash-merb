# Depends on non-ActiveSupport fiveruns-dash-ruby (>= 0.8.0)
dependency 'fiveruns-dash-ruby', '>= 0.8.0', :require_as => 'fiveruns/dash',
                                             :immediate => true
Merb::Config[:dash] ||= {
  :token => nil,
  :recipes   => [
    # This recipe can be removed, if desired
    [:merb, 'http://dash.fiveruns.com']
  ]
}

Merb::BootLoader.after_app_loads do
  Fiveruns::Dash.logger = Merb.logger
  require 'fiveruns/dash/merb'
  if Merb::Config[:adapter] != 'irb' && Merb::Config[:dash][:token]
    Fiveruns::Dash::Merb.start
  end
end