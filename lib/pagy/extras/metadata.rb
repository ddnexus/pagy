# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/metadata
# frozen_string_literal: true

require 'pagy/url_helpers'

class Pagy
  # Add a specialized backend method for pagination metadata
  module MetadataExtra
    private

    # Store the array of all the internal variable names usable as METADATA
    METADATA = %i[ scaffold_url
                   first_url
                   prev_url
                   page_url
                   next_url
                   last_url
                   count page
                   items
                   vars
                   pages
                   last
                   in
                   from
                   to
                   prev
                   next
                   series ].tap { |m| m << :sequels if DEFAULT.key?(:steps) }.freeze

    # Set the default metadata variable
    Pagy::DEFAULT[:metadata] = METADATA.dup

    include UrlHelpers

    # Return the metadata hash
    def pagy_metadata(pagy, absolute: nil)
      names   = pagy.vars[:metadata]
      unknown = names - METADATA
      raise VariableError.new(pagy, :metadata, "to be in #{DEFAULT[:metadata].inspect}", unknown) unless unknown.empty?

      scaffold_url = pagy_url_for(pagy, PAGE_PLACEHOLDER, absolute: absolute)
      {}.tap do |metadata|
        names.each do |key|
          metadata[key] = case key
                          when :scaffold_url then scaffold_url
                          when :first_url    then scaffold_url.sub(PAGE_PLACEHOLDER, 1.to_s)
                          when :prev_url     then scaffold_url.sub(PAGE_PLACEHOLDER, pagy.prev.to_s)
                          when :page_url     then scaffold_url.sub(PAGE_PLACEHOLDER, pagy.page.to_s)
                          when :next_url     then scaffold_url.sub(PAGE_PLACEHOLDER, pagy.next.to_s)
                          when :last_url     then scaffold_url.sub(PAGE_PLACEHOLDER, pagy.last.to_s)
                          else pagy.send(key)
                          end
        end
      end
    end
  end
  Backend.prepend MetadataExtra
end
