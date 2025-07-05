# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/metadata
# frozen_string_literal: true

require_relative '../url_helpers'

class Pagy # :nodoc:
  DEFAULT[:metadata] = %i[ scaffold_url first_url prev_url page_url next_url last_url
                           count page limit vars pages last in from to prev next series ]

  # Add a specialized backend method for pagination metadata
  module MetadataExtra
    private

    include UrlHelpers

    # Return the metadata hash
    def pagy_metadata(pagy, absolute: nil)
      scaffold_url = pagy_url_for(pagy, PAGE_TOKEN, absolute:)
      {}.tap do |metadata|
        keys = if defined?(::Pagy::Calendar::Unit) && pagy.is_a?(Calendar::Unit)
                 pagy.vars[:metadata] - %i[count limit]
               else
                 pagy.vars[:metadata]
               end
        keys.each do |key|
          metadata[key] = case key
                          when :scaffold_url then scaffold_url
                          when :first_url    then scaffold_url.sub(PAGE_TOKEN, 1.to_s)
                          when :prev_url     then scaffold_url.sub(PAGE_TOKEN, pagy.prev.to_s)
                          when :page_url     then scaffold_url.sub(PAGE_TOKEN, pagy.page.to_s)
                          when :next_url     then scaffold_url.sub(PAGE_TOKEN, pagy.next.to_s)
                          when :last_url     then scaffold_url.sub(PAGE_TOKEN, pagy.last.to_s)
                          else pagy.send(key)
                          end
        rescue NoMethodError
          raise VariableError.new(pagy, :metadata, 'to contain known keys', key)
        end
      end
    end
  end
  Backend.prepend MetadataExtra
end
