Styleguide::Engine.routes.draw do
  get '(:section(/:reference))' => 'sections#show',
    constraints: { reference: /(\d+\.\d+)|(\w+)/ },
    defaults: { section: 'overview', reference: 'index' },
    as: 'sections'

  root to: "sections#show"
end
