# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/support/data_pagy_attribute'
require 'json'

describe 'Pagy#data_pagy_attribute' do
  let(:pagy_class) do
    Class.new(Pagy) do
      # Expose private method for testing
      public :data_pagy_attribute
    end
  end

  let(:pagy) { pagy_class.new }

  it 'generates data-pagy attribute with encoded JSON args' do
    args = [1, 'test', { 'a' => 1 }]
    result = pagy.data_pagy_attribute(*args)

    # Extract the base64 content
    match = result.match(/data-pagy="(.+)"/)
    _(match).wont_be_nil
    encoded_data = match[1]

    # Decode and verify
    json_data = Pagy::B64.decode(encoded_data)
    decoded_args = JSON.parse(json_data)

    _(decoded_args).must_equal [1, 'test', { 'a' => 1 }]
  end

  it 'handles empty arguments' do
    result = pagy.data_pagy_attribute
    match = result.match(/data-pagy="(.+)"/)

    decoded = JSON.parse(Pagy::B64.decode(match[1]))
    _(decoded).must_equal []
  end
end
