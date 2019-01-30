=begin
#OPEX API

#No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)

OpenAPI spec version: 2.0.14-alpha

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0

=end

require 'date'

module SwaggerClient
  # Get a currency
  class PeatioCurrency
    # Currency code.
    attr_accessor :id

    # Currency name
    attr_accessor :name

    # Currency symbol
    attr_accessor :symbol

    # Currency transaction exprorer url template
    attr_accessor :explorer_transaction

    # Currency address exprorer url template
    attr_accessor :explorer_address

    # Currency type
    attr_accessor :type

    # Currency deposit fee
    attr_accessor :deposit_fee

    # Minimal deposit amount
    attr_accessor :min_deposit_amount

    # Currency withdraw fee
    attr_accessor :withdraw_fee

    # Minimal withdraw amount
    attr_accessor :min_withdraw_amount

    # Currency 24h withdraw limit
    attr_accessor :withdraw_limit_24h

    # Currency 72h withdraw limit
    attr_accessor :withdraw_limit_72h

    # Currency base factor
    attr_accessor :base_factor

    # Currency precision
    attr_accessor :precision

    # Currency icon
    attr_accessor :icon_url

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'id' => :'id',
        :'name' => :'name',
        :'symbol' => :'symbol',
        :'explorer_transaction' => :'explorer_transaction',
        :'explorer_address' => :'explorer_address',
        :'type' => :'type',
        :'deposit_fee' => :'deposit_fee',
        :'min_deposit_amount' => :'min_deposit_amount',
        :'withdraw_fee' => :'withdraw_fee',
        :'min_withdraw_amount' => :'min_withdraw_amount',
        :'withdraw_limit_24h' => :'withdraw_limit_24h',
        :'withdraw_limit_72h' => :'withdraw_limit_72h',
        :'base_factor' => :'base_factor',
        :'precision' => :'precision',
        :'icon_url' => :'icon_url'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'id' => :'String',
        :'name' => :'String',
        :'symbol' => :'String',
        :'explorer_transaction' => :'String',
        :'explorer_address' => :'String',
        :'type' => :'String',
        :'deposit_fee' => :'String',
        :'min_deposit_amount' => :'String',
        :'withdraw_fee' => :'String',
        :'min_withdraw_amount' => :'String',
        :'withdraw_limit_24h' => :'String',
        :'withdraw_limit_72h' => :'String',
        :'base_factor' => :'String',
        :'precision' => :'String',
        :'icon_url' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'name')
        self.name = attributes[:'name']
      end

      if attributes.has_key?(:'symbol')
        self.symbol = attributes[:'symbol']
      end

      if attributes.has_key?(:'explorer_transaction')
        self.explorer_transaction = attributes[:'explorer_transaction']
      end

      if attributes.has_key?(:'explorer_address')
        self.explorer_address = attributes[:'explorer_address']
      end

      if attributes.has_key?(:'type')
        self.type = attributes[:'type']
      end

      if attributes.has_key?(:'deposit_fee')
        self.deposit_fee = attributes[:'deposit_fee']
      end

      if attributes.has_key?(:'min_deposit_amount')
        self.min_deposit_amount = attributes[:'min_deposit_amount']
      end

      if attributes.has_key?(:'withdraw_fee')
        self.withdraw_fee = attributes[:'withdraw_fee']
      end

      if attributes.has_key?(:'min_withdraw_amount')
        self.min_withdraw_amount = attributes[:'min_withdraw_amount']
      end

      if attributes.has_key?(:'withdraw_limit_24h')
        self.withdraw_limit_24h = attributes[:'withdraw_limit_24h']
      end

      if attributes.has_key?(:'withdraw_limit_72h')
        self.withdraw_limit_72h = attributes[:'withdraw_limit_72h']
      end

      if attributes.has_key?(:'base_factor')
        self.base_factor = attributes[:'base_factor']
      end

      if attributes.has_key?(:'precision')
        self.precision = attributes[:'precision']
      end

      if attributes.has_key?(:'icon_url')
        self.icon_url = attributes[:'icon_url']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          id == o.id &&
          name == o.name &&
          symbol == o.symbol &&
          explorer_transaction == o.explorer_transaction &&
          explorer_address == o.explorer_address &&
          type == o.type &&
          deposit_fee == o.deposit_fee &&
          min_deposit_amount == o.min_deposit_amount &&
          withdraw_fee == o.withdraw_fee &&
          min_withdraw_amount == o.min_withdraw_amount &&
          withdraw_limit_24h == o.withdraw_limit_24h &&
          withdraw_limit_72h == o.withdraw_limit_72h &&
          base_factor == o.base_factor &&
          precision == o.precision &&
          icon_url == o.icon_url
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [id, name, symbol, explorer_transaction, explorer_address, type, deposit_fee, min_deposit_amount, withdraw_fee, min_withdraw_amount, withdraw_limit_24h, withdraw_limit_72h, base_factor, precision, icon_url].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = SwaggerClient.const_get(type).new
        temp_model.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end
  end
end