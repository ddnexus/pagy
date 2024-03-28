# lib/optimist.rb -- optimist command-line processing library
# Copyright (c) 2008-2014 William Morgan.
# Copyright (c) 2014 Red Hat, Inc.
# optimist is licensed under the MIT license.

require 'date'

module Optimist
  VERSION = "3.1.0"

  ## Thrown by Parser in the event of a commandline error. Not needed if
  ## you're using the Optimist::options entry.
  class CommandlineError < StandardError
    attr_reader :error_code

    def initialize(msg, error_code = nil)
      super(msg)
      @error_code = error_code
    end
  end

  ## Thrown by Parser if the user passes in '-h' or '--help'. Handled
  ## automatically by Optimist#options.
  class HelpNeeded < StandardError
  end

  ## Thrown by Parser if the user passes in '-v' or '--version'. Handled
  ## automatically by Optimist#options.
  class VersionNeeded < StandardError
  end

  ## Regex for floating point numbers
  FLOAT_RE = /^-?((\d+(\.\d+)?)|(\.\d+))([eE][-+]?[\d]+)?$/

  ## Regex for parameters
  PARAM_RE = /^-(-|\.$|[^\d\.])/

  ## The commandline parser. In typical usage, the methods in this class
  ## will be handled internally by Optimist::options. In this case, only the
  ## #opt, #banner and #version, #depends, and #conflicts methods will
  ## typically be called.
  ##
  ## If you want to instantiate this class yourself (for more complicated
  ## argument-parsing logic), call #parse to actually produce the output hash,
  ## and consider calling it from within
  ## Optimist::with_standard_exception_handling.
  class Parser

    ## The registry is a class-instance-variable map of option aliases to their subclassed Option class.
    @registry = {}

    ## The Option subclasses are responsible for registering themselves using this function.
    def self.register(lookup, klass)
      @registry[lookup.to_sym] = klass
    end

    ## Gets the class from the registry.
    ## Can be given either a class-name, e.g. Integer, a string, e.g "integer", or a symbol, e.g :integer
    def self.registry_getopttype(type)
      return nil unless type
      if type.respond_to?(:name)
        type = type.name
        lookup = type.downcase.to_sym
      else
        lookup = type.to_sym
      end
      raise ArgumentError, "Unsupported argument type '#{type}', registry lookup '#{lookup}'" unless @registry.has_key?(lookup)
      return @registry[lookup].new
    end

    INVALID_SHORT_ARG_REGEX = /[\d-]/ #:nodoc:

    ## The values from the commandline that were not interpreted by #parse.
    attr_reader :leftovers

    ## The complete configuration hashes for each option. (Mainly useful
    ## for testing.)
    attr_reader :specs

    ## A flag that determines whether or not to raise an error if the parser is passed one or more
    ##  options that were not registered ahead of time.  If 'true', then the parser will simply
    ##  ignore options that it does not recognize.
    attr_accessor :ignore_invalid_options

    ## Initializes the parser, and instance-evaluates any block given.
    def initialize(*a, &b)
      @version = nil
      @leftovers = []
      @specs = {}
      @long = {}
      @short = {}
      @order = []
      @constraints = []
      @stop_words = []
      @stop_on_unknown = false
      @educate_on_error = false
      @synopsis = nil
      @usage = nil

      # instance_eval(&b) if b # can't take arguments
      cloaker(&b).bind(self).call(*a) if b
    end

    ## Define an option. +name+ is the option name, a unique identifier
    ## for the option that you will use internally, which should be a
    ## symbol or a string. +desc+ is a string description which will be
    ## displayed in help messages.
    ##
    ## Takes the following optional arguments:
    ##
    ## [+:long+] Specify the long form of the argument, i.e. the form with two dashes. If unspecified, will be automatically derived based on the argument name by turning the +name+ option into a string, and replacing any _'s by -'s.
    ## [+:short+] Specify the short form of the argument, i.e. the form with one dash. If unspecified, will be automatically derived from +name+. Use :none: to not have a short value.
    ## [+:type+] Require that the argument take a parameter or parameters of type +type+. For a single parameter, the value can be a member of +SINGLE_ARG_TYPES+, or a corresponding Ruby class (e.g. +Integer+ for +:int+). For multiple-argument parameters, the value can be any member of +MULTI_ARG_TYPES+ constant. If unset, the default argument type is +:flag+, meaning that the argument does not take a parameter. The specification of +:type+ is not necessary if a +:default+ is given.
    ## [+:default+] Set the default value for an argument. Without a default value, the hash returned by #parse (and thus Optimist::options) will have a +nil+ value for this key unless the argument is given on the commandline. The argument type is derived automatically from the class of the default value given, so specifying a +:type+ is not necessary if a +:default+ is given. (But see below for an important caveat when +:multi+: is specified too.) If the argument is a flag, and the default is set to +true+, then if it is specified on the the commandline the value will be +false+.
    ## [+:required+] If set to +true+, the argument must be provided on the commandline.
    ## [+:multi+] If set to +true+, allows multiple occurrences of the option on the commandline. Otherwise, only a single instance of the option is allowed. (Note that this is different from taking multiple parameters. See below.)
    ##
    ## Note that there are two types of argument multiplicity: an argument
    ## can take multiple values, e.g. "--arg 1 2 3". An argument can also
    ## be allowed to occur multiple times, e.g. "--arg 1 --arg 2".
    ##
    ## Arguments that take multiple values should have a +:type+ parameter
    ## drawn from +MULTI_ARG_TYPES+ (e.g. +:strings+), or a +:default:+
    ## value of an array of the correct type (e.g. [String]). The
    ## value of this argument will be an array of the parameters on the
    ## commandline.
    ##
    ## Arguments that can occur multiple times should be marked with
    ## +:multi+ => +true+. The value of this argument will also be an array.
    ## In contrast with regular non-multi options, if not specified on
    ## the commandline, the default value will be [], not nil.
    ##
    ## These two attributes can be combined (e.g. +:type+ => +:strings+,
    ## +:multi+ => +true+), in which case the value of the argument will be
    ## an array of arrays.
    ##
    ## There's one ambiguous case to be aware of: when +:multi+: is true and a
    ## +:default+ is set to an array (of something), it's ambiguous whether this
    ## is a multi-value argument as well as a multi-occurrence argument.
    ## In thise case, Optimist assumes that it's not a multi-value argument.
    ## If you want a multi-value, multi-occurrence argument with a default
    ## value, you must specify +:type+ as well.

    def opt(name, desc = "", opts = {}, &b)
      opts[:callback] ||= b if block_given?
      opts[:desc] ||= desc

      o = Option.create(name, desc, opts)

      raise ArgumentError, "you already have an argument named '#{name}'" if @specs.member? o.name
      raise ArgumentError, "long option name #{o.long.inspect} is already taken; please specify a (different) :long" if @long[o.long]
      raise ArgumentError, "short option name #{o.short.inspect} is already taken; please specify a (different) :short" if @short[o.short]
      @long[o.long] = o.name
      @short[o.short] = o.name if o.short?
      @specs[o.name] = o
      @order << [:opt, o.name]
    end

    ## Sets the version string. If set, the user can request the version
    ## on the commandline. Should probably be of the form "<program name>
    ## <version number>".
    def version(s = nil)
      s ? @version = s : @version
    end

    ## Sets the usage string. If set the message will be printed as the
    ## first line in the help (educate) output and ending in two new
    ## lines.
    def usage(s = nil)
      s ? @usage = s : @usage
    end

    ## Adds a synopsis (command summary description) right below the
    ## usage line, or as the first line if usage isn't specified.
    def synopsis(s = nil)
      s ? @synopsis = s : @synopsis
    end

    ## Adds text to the help display. Can be interspersed with calls to
    ## #opt to build a multi-section help page.
    def banner(s)
      @order << [:text, s]
    end
    alias_method :text, :banner

    ## Marks two (or more!) options as requiring each other. Only handles
    ## undirected (i.e., mutual) dependencies. Directed dependencies are
    ## better modeled with Optimist::die.
    def depends(*syms)
      syms.each { |sym| raise ArgumentError, "unknown option '#{sym}'" unless @specs[sym] }
      @constraints << [:depends, syms]
    end

    ## Marks two (or more!) options as conflicting.
    def conflicts(*syms)
      syms.each { |sym| raise ArgumentError, "unknown option '#{sym}'" unless @specs[sym] }
      @constraints << [:conflicts, syms]
    end

    ## Marks two (or more!) options as required but mutually exclusive.
    def either(*syms)
      syms.each { |sym| raise ArgumentError, "unknown option '#{sym}'" unless @specs[sym] }
      @constraints << [:conflicts, syms]
      @constraints << [:either, syms]
    end

    ## Defines a set of words which cause parsing to terminate when
    ## encountered, such that any options to the left of the word are
    ## parsed as usual, and options to the right of the word are left
    ## intact.
    ##
    ## A typical use case would be for subcommand support, where these
    ## would be set to the list of subcommands. A subsequent Optimist
    ## invocation would then be used to parse subcommand options, after
    ## shifting the subcommand off of ARGV.
    def stop_on(*words)
      @stop_words = [*words].flatten
    end

    ## Similar to #stop_on, but stops on any unknown word when encountered
    ## (unless it is a parameter for an argument). This is useful for
    ## cases where you don't know the set of subcommands ahead of time,
    ## i.e., without first parsing the global options.
    def stop_on_unknown
      @stop_on_unknown = true
    end

    ## Instead of displaying "Try --help for help." on an error
    ## display the usage (via educate)
    def educate_on_error
      @educate_on_error = true
    end

    ## Parses the commandline. Typically called by Optimist::options,
    ## but you can call it directly if you need more control.
    ##
    ## throws CommandlineError, HelpNeeded, and VersionNeeded exceptions.
    def parse(cmdline = ARGV)
      vals = {}
      required = {}

      opt :version, "Print version and exit" if @version && ! (@specs[:version] || @long["version"])
      opt :help, "Show this message" unless @specs[:help] || @long["help"]

      @specs.each do |sym, opts|
        required[sym] = true if opts.required?
        vals[sym] = opts.default
        vals[sym] = [] if opts.multi && !opts.default # multi arguments default to [], not nil
      end

      resolve_default_short_options!

      ## resolve symbols
      given_args = {}
      @leftovers = each_arg cmdline do |arg, params|
        ## handle --no- forms
        arg, negative_given = if arg =~ /^--no-([^-]\S*)$/
                                ["--#{$1}", true]
                              else
                                [arg, false]
                              end

        sym = case arg
              when /^-([^-])$/      then @short[$1]
              when /^--([^-]\S*)$/  then @long[$1] || @long["no-#{$1}"]
              else                       raise CommandlineError, "invalid argument syntax: '#{arg}'"
              end

        sym = nil if arg =~ /--no-/ # explicitly invalidate --no-no- arguments

        next nil if ignore_invalid_options && !sym
        raise CommandlineError, "unknown argument '#{arg}'" unless sym

        if given_args.include?(sym) && !@specs[sym].multi?
          raise CommandlineError, "option '#{arg}' specified multiple times"
        end

        given_args[sym] ||= {}
        given_args[sym][:arg] = arg
        given_args[sym][:negative_given] = negative_given
        given_args[sym][:params] ||= []

        # The block returns the number of parameters taken.
        num_params_taken = 0

        unless params.empty?
          if @specs[sym].single_arg?
            given_args[sym][:params] << params[0, 1]  # take the first parameter
            num_params_taken = 1
          elsif @specs[sym].multi_arg?
            given_args[sym][:params] << params        # take all the parameters
            num_params_taken = params.size
          end
        end

        num_params_taken
      end

      ## check for version and help args
      raise VersionNeeded if given_args.include? :version
      raise HelpNeeded if given_args.include? :help

      ## check constraint satisfaction
      @constraints.each do |type, syms|
        constraint_sym = syms.find { |sym| given_args[sym] }

        case type
        when :depends
          next unless constraint_sym
          syms.each { |sym| raise CommandlineError, "--#{@specs[constraint_sym].long} requires --#{@specs[sym].long}" unless given_args.include? sym }
        when :conflicts
          next unless constraint_sym
          syms.each { |sym| raise CommandlineError, "--#{@specs[constraint_sym].long} conflicts with --#{@specs[sym].long}" if given_args.include?(sym) && (sym != constraint_sym) }
        when :either
          raise CommandlineError, "one of #{syms.map { |sym| "--#{@specs[sym].long}" }.join(', ') } is required" if (syms & given_args.keys).size != 1
        end
      end

      required.each do |sym, val|
        raise CommandlineError, "option --#{@specs[sym].long} must be specified" unless given_args.include? sym
      end

      ## parse parameters
      given_args.each do |sym, given_data|
        arg, params, negative_given = given_data.values_at :arg, :params, :negative_given

        opts = @specs[sym]
        if params.empty? && !opts.flag?
          raise CommandlineError, "option '#{arg}' needs a parameter" unless opts.default
          params << (opts.array_default? ? opts.default.clone : [opts.default])
        end

        vals["#{sym}_given".intern] = true # mark argument as specified on the commandline

        vals[sym] = opts.parse(params, negative_given)

        if opts.single_arg?
          if opts.multi?        # multiple options, each with a single parameter
            vals[sym] = vals[sym].map { |p| p[0] }
          else                  # single parameter
            vals[sym] = vals[sym][0][0]
          end
        elsif opts.multi_arg? && !opts.multi?
          vals[sym] = vals[sym][0]  # single option, with multiple parameters
        end
        # else: multiple options, with multiple parameters

        opts.callback.call(vals[sym]) if opts.callback
      end

      ## modify input in place with only those
      ## arguments we didn't process
      cmdline.clear
      @leftovers.each { |l| cmdline << l }

      ## allow openstruct-style accessors
      class << vals
        def method_missing(m, *_args)
          self[m] || self[m.to_s]
        end
      end
      vals
    end

    ## Print the help message to +stream+.
    def educate(stream = $stdout)
      width # hack: calculate it now; otherwise we have to be careful not to
      # call this unless the cursor's at the beginning of a line.

      left = {}
      @specs.each { |name, spec| left[name] = spec.educate }

      leftcol_width = left.values.map(&:length).max || 0
      rightcol_start = leftcol_width + 6 # spaces

      unless @order.size > 0 && @order.first.first == :text
        command_name = File.basename($0).gsub(/\.[^.]+$/, '')
        stream.puts "Usage: #{command_name} #{@usage}\n" if @usage
        stream.puts "#{@synopsis}\n" if @synopsis
        stream.puts if @usage || @synopsis
        stream.puts "#{@version}\n" if @version
        stream.puts "Options:"
      end

      @order.each do |what, opt|
        if what == :text
          stream.puts wrap(opt)
          next
        end

        spec = @specs[opt]
        stream.printf "  %-#{leftcol_width}s    ", left[opt]
        desc = spec.description_with_default

        stream.puts wrap(desc, :width => width - rightcol_start - 1, :prefix => rightcol_start)
      end
    end

    def width #:nodoc:
      @width ||= if $stdout.tty?
                   begin
                     require 'io/console'
                     w = IO.console.winsize.last
                     w.to_i > 0 ? w : 80
                   rescue LoadError, NoMethodError, Errno::ENOTTY, Errno::EBADF, Errno::EINVAL
                     legacy_width
                   end
                 else
                   80
                 end
    end

    def legacy_width
      # Support for older Rubies where io/console is not available
      `tput cols`.to_i
    rescue Errno::ENOENT
      80
    end
    private :legacy_width

    def wrap(str, opts = {}) # :nodoc:
      if str == ""
        [""]
      else
        inner = false
        str.split("\n").map do |s|
          line = wrap_line s, opts.merge(:inner => inner)
          inner = true
          line
        end.flatten
      end
    end

    ## The per-parser version of Optimist::die (see that for documentation).
    def die(arg, msg = nil, error_code = nil)
      msg, error_code = nil, msg if msg.kind_of?(Integer)
      if msg
        $stderr.puts "Error: argument --#{@specs[arg].long} #{msg}."
      else
        $stderr.puts "Error: #{arg}."
      end
      if @educate_on_error
        $stderr.puts
        educate $stderr
      else
        $stderr.puts "Try --help for help."
      end
      exit(error_code || -1)
    end

    private

    ## yield successive arg, parameter pairs
    def each_arg(args)
      remains = []
      i = 0

      until i >= args.length
        return remains += args[i..-1] if @stop_words.member? args[i]
        case args[i]
        when /^--$/ # arg terminator
          return remains += args[(i + 1)..-1]
        when /^--(\S+?)=(.*)$/ # long argument with equals
          num_params_taken = yield "--#{$1}", [$2]
          if num_params_taken.nil?
            remains << args[i]
            if @stop_on_unknown
              return remains += args[i + 1..-1]
            end
          end
          i += 1
        when /^--(\S+)$/ # long argument
          params = collect_argument_parameters(args, i + 1)
          num_params_taken = yield args[i], params

          if num_params_taken.nil?
            remains << args[i]
            if @stop_on_unknown
              return remains += args[i + 1..-1]
            end
          else
            i += num_params_taken
          end
          i += 1
        when /^-(\S+)$/ # one or more short arguments
          short_remaining = ""
          shortargs = $1.split(//)
          shortargs.each_with_index do |a, j|
            if j == (shortargs.length - 1)
              params = collect_argument_parameters(args, i + 1)

              num_params_taken = yield "-#{a}", params
              unless num_params_taken
                short_remaining << a
                if @stop_on_unknown
                  remains << "-#{short_remaining}"
                  return remains += args[i + 1..-1]
                end
              else
                i += num_params_taken
              end
            else
              unless yield "-#{a}", []
                short_remaining << a
                if @stop_on_unknown
                  short_remaining += shortargs[j + 1..-1].join
                  remains << "-#{short_remaining}"
                  return remains += args[i + 1..-1]
                end
              end
            end
          end

          unless short_remaining.empty?
            remains << "-#{short_remaining}"
          end
          i += 1
        else
          if @stop_on_unknown
            return remains += args[i..-1]
          else
            remains << args[i]
            i += 1
          end
        end
      end

      remains
    end

    def collect_argument_parameters(args, start_at)
      params = []
      pos = start_at
      while args[pos] && args[pos] !~ PARAM_RE && !@stop_words.member?(args[pos]) do
        params << args[pos]
        pos += 1
      end
      params
    end

    def resolve_default_short_options!
      @order.each do |type, name|
        opts = @specs[name]
        next if type != :opt || opts.short

        c = opts.long.split(//).find { |d| d !~ INVALID_SHORT_ARG_REGEX && !@short.member?(d) }
        if c # found a character to use
          opts.short = c
          @short[c] = name
        end
      end
    end

    def wrap_line(str, opts = {})
      prefix = opts[:prefix] || 0
      width = opts[:width] || (self.width - 1)
      start = 0
      ret = []
      until start > str.length
        nextt =
        if start + width >= str.length
          str.length
        else
          x = str.rindex(/\s/, start + width)
          x = str.index(/\s/, start) if x && x < start
          x || str.length
        end
        ret << ((ret.empty? && !opts[:inner]) ? "" : " " * prefix) + str[start...nextt]
        start = nextt + 1
      end
      ret
    end

    ## instance_eval but with ability to handle block arguments
    ## thanks to _why: http://redhanded.hobix.com/inspect/aBlockCostume.html
    def cloaker(&b)
      (class << self; self; end).class_eval do
        define_method :cloaker_, &b
        meth = instance_method :cloaker_
        remove_method :cloaker_
        meth
      end
    end
  end

  class Option

    attr_accessor :name, :short, :long, :default
    attr_writer :multi_given

    def initialize
      @long = nil
      @short = nil
      @name = nil
      @multi_given = false
      @hidden = false
      @default = nil
      @optshash = Hash.new()
    end

    def opts(key)
      @optshash[key]
    end

    def opts=(o)
      @optshash = o
    end

    ## Indicates a flag option, which is an option without an argument
    def flag? ; false ; end
    def single_arg?
      !self.multi_arg? && !self.flag?
    end

    def multi ; @multi_given ; end
    alias multi? multi

    ## Indicates that this is a multivalued (Array type) argument
    def multi_arg? ; false ; end
    ## note: Option-Types with both multi_arg? and flag? false are single-parameter (normal) options.

    def array_default? ; self.default.kind_of?(Array) ; end

    def short? ; short && short != :none ; end

    def callback ; opts(:callback) ; end
    def desc ; opts(:desc) ; end

    def required? ; opts(:required) ; end

    def parse(_paramlist, _neg_given)
      raise NotImplementedError, "parse must be overridden for newly registered type"
    end

    # provide type-format string.  default to empty, but user should probably override it
    def type_format ; "" ; end

    def educate
      (short? ? "-#{short}, " : "") + "--#{long}" + type_format + (flag? && default ? ", --no-#{long}" : "")
    end

    ## Format the educate-line description including the default-value(s)
    def description_with_default
      return desc unless default
      default_s = case default
                  when $stdout   then '<stdout>'
                  when $stdin    then '<stdin>'
                  when $stderr   then '<stderr>'
                  when Array
                    default.join(', ')
                  else
                    default.to_s
                  end
      defword = desc.end_with?('.') ? 'Default' : 'default'
      return "#{desc} (#{defword}: #{default_s})"
    end

    ## Provide a way to register symbol aliases to the Parser
    def self.register_alias(*alias_keys)
      alias_keys.each do |alias_key|
        # pass in the alias-key and the class
        Parser.register(alias_key, self)
      end
    end

    ## Factory class methods ...

    # Determines which type of object to create based on arguments passed
    # to +Optimist::opt+.  This is trickier in Optimist, than other cmdline
    # parsers (e.g. Slop) because we allow the +default:+ to be able to
    # set the option's type.
    def self.create(name, desc="", opts={}, settings={})

      opttype = Optimist::Parser.registry_getopttype(opts[:type])
      opttype_from_default = get_klass_from_default(opts, opttype)

      raise ArgumentError, ":type specification and default type don't match (default type is #{opttype_from_default.class})" if opttype && opttype_from_default && (opttype.class != opttype_from_default.class)

      opt_inst = (opttype || opttype_from_default || Optimist::BooleanOption.new)

      ## fill in :long
      opt_inst.long = handle_long_opt(opts[:long], name)

      ## fill in :short
      opt_inst.short = handle_short_opt(opts[:short])

      ## fill in :multi
      multi_given = opts[:multi] || false
      opt_inst.multi_given = multi_given

      ## fill in :default for flags
      defvalue = opts[:default] || opt_inst.default

      ## autobox :default for :multi (multi-occurrence) arguments
      defvalue = [defvalue] if defvalue && multi_given && !defvalue.kind_of?(Array)
      opt_inst.default = defvalue
      opt_inst.name = name
      opt_inst.opts = opts
      opt_inst
    end

    private

    def self.get_type_from_disdef(optdef, opttype, disambiguated_default)
      if disambiguated_default.is_a? Array
        return(optdef.first.class.name.downcase + "s") if !optdef.empty?
        if opttype
          raise ArgumentError, "multiple argument type must be plural" unless opttype.multi_arg?
          return nil
        else
          raise ArgumentError, "multiple argument type cannot be deduced from an empty array"
        end
      end
      return disambiguated_default.class.name.downcase
    end

    def self.get_klass_from_default(opts, opttype)
      ## for options with :multi => true, an array default doesn't imply
      ## a multi-valued argument. for that you have to specify a :type
      ## as well. (this is how we disambiguate an ambiguous situation;
      ## see the docs for Parser#opt for details.)

      disambiguated_default = if opts[:multi] && opts[:default].is_a?(Array) && opttype.nil?
                                opts[:default].first
                              else
                                opts[:default]
                              end

      return nil if disambiguated_default.nil?
      type_from_default = get_type_from_disdef(opts[:default], opttype, disambiguated_default)
      return Optimist::Parser.registry_getopttype(type_from_default)
    end

    def self.handle_long_opt(lopt, name)
      lopt = lopt ? lopt.to_s : name.to_s.gsub("_", "-")
      lopt = case lopt
             when /^--([^-].*)$/ then $1
             when /^[^-]/        then lopt
             else                     raise ArgumentError, "invalid long option name #{lopt.inspect}"
             end
    end

    def self.handle_short_opt(sopt)
      sopt = sopt.to_s if sopt && sopt != :none
      sopt = case sopt
             when /^-(.)$/          then $1
             when nil, :none, /^.$/ then sopt
             else                   raise ArgumentError, "invalid short option name '#{sopt.inspect}'"
             end

      if sopt
        raise ArgumentError, "a short option name can't be a number or a dash" if sopt =~ ::Optimist::Parser::INVALID_SHORT_ARG_REGEX
      end
      return sopt
    end

  end

  # Flag option.  Has no arguments. Can be negated with "no-".
  class BooleanOption < Option
    register_alias :flag, :bool, :boolean, :trueclass, :falseclass
    def initialize
      super()
      @default = false
    end
    def flag? ; true ; end
    def parse(_paramlist, neg_given)
      return(self.name.to_s =~ /^no_/ ? neg_given : !neg_given)
    end
  end

  # Floating point number option class.
  class FloatOption < Option
    register_alias :float, :double
    def type_format ; "=<f>" ; end
    def parse(paramlist, _neg_given)
      paramlist.map do |pg|
        pg.map do |param|
          raise CommandlineError, "option '#{self.name}' needs a floating-point number" unless param.is_a?(Numeric) || param =~ FLOAT_RE
          param.to_f
        end
      end
    end
  end

  # Integer number option class.
  class IntegerOption < Option
    register_alias :int, :integer, :fixnum
    def type_format ; "=<i>" ; end
    def parse(paramlist, _neg_given)
      paramlist.map do |pg|
        pg.map do |param|
          raise CommandlineError, "option '#{self.name}' needs an integer" unless param.is_a?(Numeric) || param =~ /^-?[\d_]+$/
          param.to_i
        end
      end
    end
  end

  # Option class for handling IO objects and URLs.
  # Note that this will return the file-handle, not the file-name
  # in the case of file-paths given to it.
  class IOOption < Option
    register_alias :io
    def type_format ; "=<filename/uri>" ; end
    def parse(paramlist, _neg_given)
      paramlist.map do |pg|
        pg.map do |param|
          if param =~ /^(stdin|-)$/i
            $stdin
          else
            require 'open-uri'
            begin
              open param
            rescue SystemCallError => e
              raise CommandlineError, "file or url for option '#{self.name}' cannot be opened: #{e.message}"
            end
          end
        end
      end
    end
  end

  # Option class for handling Strings.
  class StringOption < Option
    register_alias :string
    def type_format ; "=<s>" ; end
    def parse(paramlist, _neg_given)
      paramlist.map { |pg| pg.map(&:to_s) }
    end
  end

  # Option for dates.  Uses Chronic if it exists.
  class DateOption < Option
    register_alias :date
    def type_format ; "=<date>" ; end
    def parse(paramlist, _neg_given)
      paramlist.map do |pg|
        pg.map do |param|
          next param if param.is_a?(Date)
          begin
            begin
              require 'chronic'
              time = Chronic.parse(param)
            rescue LoadError
              # chronic is not available
            end
            time ? Date.new(time.year, time.month, time.day) : Date.parse(param)
          rescue ArgumentError
            raise CommandlineError, "option '#{self.name}' needs a date"
          end
        end
      end
    end
  end

  ### MULTI_OPT_TYPES :
  ## The set of values that indicate a multiple-parameter option (i.e., that
  ## takes multiple space-separated values on the commandline) when passed as
  ## the +:type+ parameter of #opt.

  # Option class for handling multiple Integers
  class IntegerArrayOption < IntegerOption
    register_alias :fixnums, :ints, :integers
    def type_format ; "=<i+>" ; end
    def multi_arg? ; true ; end
  end

  # Option class for handling multiple Floats
  class FloatArrayOption < FloatOption
    register_alias :doubles, :floats
    def type_format ; "=<f+>" ; end
    def multi_arg? ; true ; end
  end

  # Option class for handling multiple Strings
  class StringArrayOption < StringOption
    register_alias :strings
    def type_format ; "=<s+>" ; end
    def multi_arg? ; true ; end
  end

  # Option class for handling multiple dates
  class DateArrayOption < DateOption
    register_alias :dates
    def type_format ; "=<date+>" ; end
    def multi_arg? ; true ; end
  end

  # Option class for handling Files/URLs via 'open'
  class IOArrayOption < IOOption
    register_alias :ios
    def type_format ; "=<filename/uri+>" ; end
    def multi_arg? ; true ; end
  end

  ## The easy, syntactic-sugary entry method into Optimist. Creates a Parser,
  ## passes the block to it, then parses +args+ with it, handling any errors or
  ## requests for help or version information appropriately (and then exiting).
  ## Modifies +args+ in place. Returns a hash of option values.
  ##
  ## The block passed in should contain zero or more calls to +opt+
  ## (Parser#opt), zero or more calls to +text+ (Parser#text), and
  ## probably a call to +version+ (Parser#version).
  ##
  ## The returned block contains a value for every option specified with
  ## +opt+.  The value will be the value given on the commandline, or the
  ## default value if the option was not specified on the commandline. For
  ## every option specified on the commandline, a key "<option
  ## name>_given" will also be set in the hash.
  ##
  ## Example:
  ##
  ##   require 'optimist'
  ##   opts = Optimist::options do
  ##     opt :monkey, "Use monkey mode"                    # a flag --monkey, defaulting to false
  ##     opt :name, "Monkey name", :type => :string        # a string --name <s>, defaulting to nil
  ##     opt :num_limbs, "Number of limbs", :default => 4  # an integer --num-limbs <i>, defaulting to 4
  ##   end
  ##
  ##   ## if called with no arguments
  ##   p opts # => {:monkey=>false, :name=>nil, :num_limbs=>4, :help=>false}
  ##
  ##   ## if called with --monkey
  ##   p opts # => {:monkey=>true, :name=>nil, :num_limbs=>4, :help=>false, :monkey_given=>true}
  ##
  ## See more examples at http://optimist.rubyforge.org.
  def options(args = ARGV, *a, &b)
    @last_parser = Parser.new(*a, &b)
    with_standard_exception_handling(@last_parser) { @last_parser.parse args }
  end

  ## If Optimist::options doesn't do quite what you want, you can create a Parser
  ## object and call Parser#parse on it. That method will throw CommandlineError,
  ## HelpNeeded and VersionNeeded exceptions when necessary; if you want to
  ## have these handled for you in the standard manner (e.g. show the help
  ## and then exit upon an HelpNeeded exception), call your code from within
  ## a block passed to this method.
  ##
  ## Note that this method will call System#exit after handling an exception!
  ##
  ## Usage example:
  ##
  ##   require 'optimist'
  ##   p = Optimist::Parser.new do
  ##     opt :monkey, "Use monkey mode"                     # a flag --monkey, defaulting to false
  ##     opt :goat, "Use goat mode", :default => true       # a flag --goat, defaulting to true
  ##   end
  ##
  ##   opts = Optimist::with_standard_exception_handling p do
  ##     o = p.parse ARGV
  ##     raise Optimist::HelpNeeded if ARGV.empty? # show help screen
  ##     o
  ##   end
  ##
  ## Requires passing in the parser object.

  def with_standard_exception_handling(parser)
    yield
  rescue CommandlineError => e
    parser.die(e.message, nil, e.error_code)
  rescue HelpNeeded
    parser.educate
    exit
  rescue VersionNeeded
    puts parser.version
    exit
  end

  ## Informs the user that their usage of 'arg' was wrong, as detailed by
  ## 'msg', and dies. Example:
  ##
  ##   options do
  ##     opt :volume, :default => 0.0
  ##   end
  ##
  ##   die :volume, "too loud" if opts[:volume] > 10.0
  ##   die :volume, "too soft" if opts[:volume] < 0.1
  ##
  ## In the one-argument case, simply print that message, a notice
  ## about -h, and die. Example:
  ##
  ##   options do
  ##     opt :whatever # ...
  ##   end
  ##
  ##   Optimist::die "need at least one filename" if ARGV.empty?
  ##
  ## An exit code can be provide if needed
  ##
  ##   Optimist::die "need at least one filename", -2 if ARGV.empty?
  def die(arg, msg = nil, error_code = nil)
    if @last_parser
      @last_parser.die arg, msg, error_code
    else
      raise ArgumentError, "Optimist::die can only be called after Optimist::options"
    end
  end

  ## Displays the help message and dies. Example:
  ##
  ##   options do
  ##     opt :volume, :default => 0.0
  ##     banner <<-EOS
  ##   Usage:
  ##          #$0 [options] <name>
  ##   where [options] are:
  ##   EOS
  ##   end
  ##
  ##   Optimist::educate if ARGV.empty?
  def educate
    if @last_parser
      @last_parser.educate
      exit
    else
      raise ArgumentError, "Optimist::educate can only be called after Optimist::options"
    end
  end

  module_function :options, :die, :educate, :with_standard_exception_handling
end # module
