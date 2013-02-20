module SpreeBraspag
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_braspag\n"
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_braspag\n"
      end

      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_braspag\n", :before => /\*\//, :verbose => true
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_braspag\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_braspag'
      end

      def add_rack_environment
        append_file 'config/environment.rb', "\nENV[\"BRASPAG_ENV\"] ||= Rails.env\n"
        puts 'Adding rack env to config/environment.rb'
      end

      def run_migrations
         res = ask 'Would you like to run the migrations now? [Y/n]'
         if res == '' || res.downcase == 'y'
           run 'bundle exec rake db:migrate'
         else
           puts 'Skipping rake db:migrate, don\'t forget to run it!'
         end
      end
    end
  end
end
