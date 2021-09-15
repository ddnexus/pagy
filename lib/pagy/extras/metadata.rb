# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/metadata
# frozen_string_literal: true

class Pagy
  # Add a specialized backend method for pagination metadata
  module MetadataExtra
    private

    METADATA = %i[scaffold_url first_url prev_url page_url next_url last_url
                  count page items vars pages last in from to prev next series].tap do |metadata|
                 metadata << :sequels if VARS.key?(:steps)  # :steps gets defined along with the #sequels method
               end.freeze

    Pagy::VARS[:metadata] = METADATA.dup

    include Helpers

    def pagy_metadata(pagy, absolute: nil)
      names   = pagy.vars[:metadata]
      unknown = names - METADATA
      raise VariableError.new(pagy), "unknown metadata #{unknown.inspect}" \
            unless unknown.empty?

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
