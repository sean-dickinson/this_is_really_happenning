Rails.application.config.generators do |g|
  g.helper false
  g.jbuilder false
  g.test_framework :rspec,
    fixtures: false,
    view_specs: false,
    helper_specs: false,
    routing_specs: false,
    controller_specs: false
end
