# Tasks used within the development of BlacklightHeatmaps

require 'solr_wrapper'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
end


EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

desc 'Run test suite'
task ci: ['blacklight_heatmaps:generate'] do
  SolrWrapper.wrap do |solr|
    solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('..', File.dirname(__FILE__)), 'solr', 'conf')) do
      within_test_app do
        system 'RAILS_ENV=test rake blacklight_heatmaps:index:seed'
      end
      Rake::Task['spec'].invoke
    end
  end
end

namespace :blacklight_heatmaps do
  desc 'Generate a test application'
  task generate: ['engine_cart:generate'] do
  end

  desc 'Run Solr and Blacklight for interactive development'
  task :server, [:rails_server_args] do |_t, args|
    if File.exist? EngineCart.destination
      within_test_app do
        system 'bundle update'
      end
    else
      Rake::Task['engine_cart:generate'].invoke
    end

    SolrWrapper.wrap(port: '8983') do |solr|
      solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('..', File.dirname(__FILE__)), 'solr', 'conf')) do

        within_test_app do
          system 'RAILS_ENV=development rake blacklight_heatmaps:index:seed'
          system "bundle exec rails s #{args[:rails_server_args]}"
        end
      end
    end
  end
end
