module Pay
  class Engine < ::Rails::Engine
    isolate_namespace Pay

    initializer 'pay.processors' do
      # Include processor backends
      require 'pay/stripe'    if defined? ::Stripe
      require 'pay/braintree' if defined? ::Braintree

      ActiveSupport::Reloader.to_prepare do
        Pay::Stripe.setup    if defined? ::Stripe
        Pay::Braintree.setup if defined? ::Braintree

        if defined?(Receipts::Receipt)
          Pay.charge_model.include Pay::Receipts
        end
      end
    end
  end
end
