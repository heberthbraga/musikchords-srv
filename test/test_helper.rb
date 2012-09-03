require 'simplecov'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

SimpleCov.root Rails.root
SimpleCov.coverage_dir "doc/coverage"

require 'shoulda'
require 'always_execute'
require 'database_cleaner'

Mocha::Configuration.prevent(:stubbing_non_existent_method)

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  setup do
    database_cleaner_up
  end
  
  teardown do
    database_cleaner_down
  end
end

class ActionDispatch::IntegrationTest
  setup do
    database_cleaner_up
  end
  
  teardown do
    database_cleaner_down
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    database_cleaner_up
  end
  
  teardown do
    database_cleaner_down
  end
end

def database_cleaner_up
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.orm = 'mongo_mapper'
end

def database_cleaner_down
  DatabaseCleaner.clean
end

class Object
  # This allows you to be a good OOP citizen and honor encapsulation, but
  # still make calls to private methods (for testing) by doing
  #
  #   obj.bypass.private_thingie(arg1, arg2)
  #
  # Which is easier on the eye than
  #
  #   obj.send(:private_thingie, arg1, arg2)
  #
  class Bypass
    instance_methods.each do |m|
      undef_method m unless m =~ /^__/ || m == :object_id
    end

    def initialize(ref)
      @ref = ref
    end

    def method_missing(sym, *args, &block)
      @ref.__send__(sym, *args, &block)
    end
  end

  def bypass
    Bypass.new(self)
  end
end

class Shoulda::Context
  def raises(*args, &raises_block)
    expected_exceptions = args
    test_name_qualifier = args.last.is_a?(String) ? (' ' + args.pop) : ''

    context nil do
      setup do
        if @execute_block.nil?
          flunk "raises requires a corresponding execute block"
        end

        @old_execute_block = @execute_block

        @execute_block = lambda do
          begin
            @old_execute_block.bind(self).call
          rescue => exception
          end

          unless exception
            flunk "#{expected_exceptions.inspect} expected but nothing was raised"
          end

          exception
        end
      end

      should "raise #{expected_exceptions.inspect}#{test_name_qualifier}" do
        if expected_exceptions.none?{|ee| @execute_result.is_a?(ee)}
          flunk [
            "#{expected_exceptions.inspect} exception expected, not #{@execute_result.class.name}",
            "Message: #{@execute_result.message}",
            "---Backtrace---",
            "#{@execute_result.backtrace.join("\n")}",
            "---------------"
            ].join("\n")
          end

          raises_block.bind(self).call unless raises_block.nil?
        end
      end
    end
end