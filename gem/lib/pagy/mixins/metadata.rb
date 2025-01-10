# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/metadata
# frozen_string_literal: true

require_relative '../url_helpers'

class Pagy
  DEFAULT[:metadata] = %i[url_template first_url prev_url page_url next_url last_url
                          count page limit pages last in from to prev next vars series sequels]

  # Add a specialized backend method for pagination metadata
  Backend.class_eval do
    private

    include UrlHelpers

    # Return the metadata hash
    def pagy_metadata(pagy, absolute: nil)
      url_template = pagy_page_url(pagy, PAGE_TOKEN, absolute:)
      # If it's not in the vars, the autoloading kicked-in after the object creation,
      # which means that no custom DEFAULT has been set, so we use the original
      keys  = pagy.vars[:metadata] || DEFAULT[:metadata]
      keys -= %i[count limit] if defined?(::Pagy::Offset::Calendar::Unit) && pagy.is_a?(Offset::Calendar::Unit)
      {}.tap do |metadata|
        keys.each do |key|
          metadata[key] = case key
                          when :url_template then url_template
                          when :first_url    then url_template.sub(PAGE_TOKEN, 1.to_s)
                          when :prev_url     then url_template.sub(PAGE_TOKEN, pagy.prev.to_s)
                          when :page_url     then url_template.sub(PAGE_TOKEN, pagy.page.to_s)
                          when :next_url     then url_template.sub(PAGE_TOKEN, pagy.next.to_s)
                          when :last_url     then url_template.sub(PAGE_TOKEN, pagy.last.to_s)
                          else pagy.send(key)
                          end
        rescue NoMethodError
          raise VariableError.new(pagy, :metadata, 'to contain known keys', key)
        end
      end
    end
  end
end
