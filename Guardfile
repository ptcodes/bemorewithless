# vim: ft=ruby
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group :dev do
  guard 'rails' do
    watch('Gemfile.lock')
    #watch(%r{(config|app/helpers)/.*})
    watch(%r{lib/.+\.rb})
  end

  guard 'livereload', :apply_js_live => false do
    watch(%r{app/.+\.(erb|haml)})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{(public/|app/assets).+\.(css|js|html)})
    watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
    watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
    watch(%r{config/locales/.+\.yml})
  end

  #guard 'delayed' do
    #watch(%r{^app/(.+)\.rb})
  #end

  guard 'annotate' do
    watch( 'db/schema.rb' )
    # Uncomment the following line if you also want to run annotate anytime
    # a model file changes
    watch( 'app/models/*.rb' )
  end
end

group :test do
  guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false, :cucumber => false do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch(%r{^spec/support/(.+)\.rb$})
  end

  guard 'rspec', :version => 2, :cli => "--format documentation --drb --profile" do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
    # watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch('spec/spec_helper.rb')                        { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  end
end

