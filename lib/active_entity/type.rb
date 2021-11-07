# frozen_string_literal: true

require "active_model/type"

require "active_entity/type/internal/timezone"

require "active_entity/type/date"
require "active_entity/type/date_time"
require "active_entity/type/json"
require "active_entity/type/time"
require "active_entity/type/text"
require "active_entity/type/unsigned_integer"

require "active_entity/type/modifiers/array"
require "active_entity/type/modifiers/array_without_blank"

require "active_entity/type/serialized"
require "active_entity/type/registry"

module ActiveEntity
  module Type
    @registry = Registry.new

    class << self
      attr_accessor :registry # :nodoc:
      delegate :add_modifier, to: :registry

      # Add a new type to the registry, allowing it to be referenced as a
      # symbol by {ActiveEntity::Base.attribute}[rdoc-ref:Attributes::ClassMethods#attribute].
      # If your type is only meant to be used with a specific database adapter, you can
      # do so by passing <tt>adapter: :postgresql</tt>. If your type has the same
      # name as a native type for the current adapter, an exception will be
      # raised unless you specify an +:override+ option. <tt>override: true</tt> will
      # cause your type to be used instead of the native type. <tt>override:
      # false</tt> will cause the native type to be used over yours if one exists.
      def register(type_name, klass = nil, &block)
        registry.register(type_name, klass, &block)
      end

      def lookup(*args, **kwargs) # :nodoc:
        registry.lookup(*args, **kwargs)
      end

      def default_value # :nodoc:
        @default_value ||= Value.new
      end
    end

    BigInteger = ActiveModel::Type::BigInteger
    Binary = ActiveModel::Type::Binary
    Boolean = ActiveModel::Type::Boolean
    Decimal = ActiveModel::Type::Decimal
    Float = ActiveModel::Type::Float
    Integer = ActiveModel::Type::Integer
    String = ActiveModel::Type::String
    Value = ActiveModel::Type::Value

    # TODO: Fix modifier support in Registry
    # add_modifier({ array: true }, Modifiers::Array)
    # add_modifier({ array_without_blank: true }, Modifiers::ArrayWithoutBlank)

    register(:big_integer, Type::BigInteger)
    register(:binary, Type::Binary)
    register(:boolean, Type::Boolean)
    register(:date, Type::Date)
    register(:datetime, Type::DateTime)
    register(:decimal, Type::Decimal)
    register(:float, Type::Float)
    register(:integer, Type::Integer)
    register(:unsigned_integer, Type::UnsignedInteger)
    register(:json, Type::Json)
    register(:string, Type::String)
    register(:text, Type::Text)
    register(:time, Type::Time)
  end
end
