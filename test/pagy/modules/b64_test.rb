# frozen_string_literal: true

require 'test_helper'
require 'pagy/modules/b64'

describe Pagy::B64 do
  let(:b64) { Pagy::B64 }

  describe 'standard methods' do
    it 'encodes and decodes simple strings' do
      str = 'Simple String'
      # 'm0' should not add newlines
      encoded = b64.encode(str)
      _(encoded).must_equal "U2ltcGxlIFN0cmluZw=="

      _(b64.decode(encoded)).must_equal str
    end

    it 'roundtrips binary data' do
      # \xff\xff produces ///... in base64 which are sensitive chars
      # Force binary encoding to match decoder output
      data = "\xff\xff\xff\x00".b
      encoded = b64.encode(data)
      decoded = b64.decode(encoded)
      _(decoded).must_equal data
    end
  end

  describe 'urlsafe methods' do
    # "Subject" -> "U3ViamVjdA==" (Standard) -> "U3ViamVjdA" (URL safe no padding)
    # "\xff\xef" -> "/+8=" (Standard) -> "_-8" (URL safe, replaced +/, removed =)

    it 'encodes urlsafe (removes padding and replaces chars)' do
      # Case 1: Padding removal
      # 'a' -> 'YQ==' -> 'YQ'
      _(b64.urlsafe_encode('a')).must_equal 'YQ'

      # Case 2: + and / replacement
      # \xff\xef -> /+8= -> _-8
      data = "\xff\xef".b
      _(b64.urlsafe_encode(data)).must_equal '_-8'
    end

    it 'decodes urlsafe (restores padding and chars)' do
      # Case 1: Restore padding
      _(b64.urlsafe_decode('YQ')).must_equal 'a'

      # Case 2: Restore + and /
      data = "\xff\xef".b
      # _-8 -> /+8= -> decoded
      _(b64.urlsafe_decode('_-8')).must_equal data
    end

    it 'handles standard urlsafe strings (no mod needed)' do
      str = 'Ruby'
      # Ruby -> UnVieQ== -> UnVieQ
      encoded = b64.urlsafe_encode(str)
      _(encoded).must_equal 'UnVieQ'
      _(b64.urlsafe_decode(encoded)).must_equal str
    end

    it 'handles various padding lengths' do
      # 1 byte input -> 2 padding chars needed
      _(b64.urlsafe_decode(b64.urlsafe_encode('1'))).must_equal '1'
      # 2 bytes input -> 1 padding char needed
      _(b64.urlsafe_decode(b64.urlsafe_encode('12'))).must_equal '12'
      # 3 bytes input -> 0 padding chars needed
      _(b64.urlsafe_decode(b64.urlsafe_encode('123'))).must_equal '123'
    end
  end
end
