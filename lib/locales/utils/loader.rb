# encoding: utf-8
# frozen_string_literal: true

# the whole file will be eval'ed/executed and gc-collected after returning/executing the loader proc

# eval: no need for the whole file in memory
plurals, _ = eval(Pagy.root.join('locales', 'utils', 'p11n.rb').read)   #rubocop:disable Security/Eval

# flatten the dictionary file nested keys
# convert each value to a simple ruby interpolation proc
flatten = lambda do |hash, key=''|
            hash.each.reduce({}) do |h, (k, v)|
              v.is_a?(Hash) \
                ? h.merge!(flatten.call(v, "#{key}#{k}."))
                : h.merge!(eval %({"#{key}#{k}" => lambda{|vars|"#{v.gsub(/%{[^}]+?}/){|m| "\#{vars[:#{m[2..-2]}]||'#{m}'}" }}"}})) #rubocop:disable Security/Eval
            end
          end

# loader proc
lambda do |i18n, *args|
  i18n.clear
  args.each do |arg|
    arg[:filepath]  ||= Pagy.root.join('locales', "#{arg[:locale]}.yml")
    arg[:pluralize] ||= plurals[arg[:locale]]
    hash = YAML.load(File.read(arg[:filepath], encoding: 'UTF-8')) #rubocop:disable Security/YAMLLoad
    hash.key?(arg[:locale]) or raise VariableError, %(expected :locale "#{arg[:locale]}" not found in :filepath "#{arg[:filepath].inspect}")
    i18n[arg[:locale]] = [flatten.call(hash[arg[:locale]]), arg[:pluralize]]
  end
end
