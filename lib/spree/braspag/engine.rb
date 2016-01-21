module Spree
  module Braspag
    class Engine < Rails::Engine
      engine_name 'spree_braspag'
      isolate_namespace Spree::Braspag

      config.autoload_paths += %W(#{config.root}/lib)

      config.generators do |g|
        g.test_framework :rspec
      end

      initializer 'spree.braspag.preferences', before: :load_config_initializers do |app|
        Spree::Braspag::Config = Spree::BraspagConfiguration.new
      end

      def self.activate
        source_attrs = Spree::PermittedAttributes.source_attributes
        source_attrs << :installments unless  source_attrs.include?(:installments)

        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      initializer "spree_braspag.register.payment_methods", after: 'spree.register.payment_methods'  do |app|
        app.config.spree.payment_methods += [
          Gateway::BraspagBill,
          Gateway::BraspagCreditcard
        ]
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end