# encoding: UTF-8
module Maintain
  class Maintainer
    attr_reader :back_end

    class << self
      def call_method_or_proc(method, instance)
        if method.is_a?(Proc)
          instance.instance_eval(&method)
        else
          instance.send(method)
        end
      end
    end

    def aggregate(name, conditions, options = {})
      if conditions.is_a?(Hash) && conditions.has_key?(:as)
        options = conditions
        conditions = options[:as]
      end
      aggregates[name] = conditions

      # Now we're going to add proxies to test for state being in this
      # aggregate. Don't create this method unless it doesn't exist.
      boolean_method = "#{name}?"
      if method_free?(boolean_method)
        # Define it if'n it don't already exist! These are just proxies - so
        # Foo.maintains(:state) { state :awesome } will now have
        # Foo.new.awesome?. But that's really just a proxy for
        # Foo.new.state.awesome?
        # So they're just shortcuts for brevity's sake.
        maintainee.class_eval <<-EOC
          def #{boolean_method}
            #{@attribute}.#{boolean_method}
          end
        EOC
      end

      # Now define the state
      if back_end
        conditions = conditions.select { |value| states.has_key?(value) }
        conditions = conditions.map do |value|
          if states[value][:value].is_a?(Symbol)
            states[value][:value].to_s
          else
            states[value][:value]
          end
        end
        conditions = conditions.compact
        back_end.aggregate(maintainee, name, @attribute, conditions, {
          force: options[:force]
        })
      end
    end

    def aggregates
      @aggregates ||= {}
    end

    def bitmask(value)
      @bitmask = !!value
    end

    def bitmask?
      !!@bitmask
    end

    def default(state = nil)
      if state
        if bitmask?
          @default = (@default || 0) | states[state][:value]
        else
          @default = state
        end
      else
        @default
      end
    end

    def default?
      !!@default
    end

    def hook(event, state, instance)
      if state && state.to_s.strip != '' && hooks[state.to_sym]
        hook_definitions = hooks[state.to_sym][event.to_sym] || []
        hook_definitions.each do |hook_definition|
          if hook_definition[:if]
            next unless call_method_or_proc(hook_definition[:if], instance)
          end
          if hook_definition[:unless]
            next if call_method_or_proc(hook_definition[:unless], instance)
          end
          call_method_or_proc(hook_definition[:method], instance)
        end
      end
    end

    def initialize(maintainee, attribute, options = {})
      @maintainee = maintainee.name
      @attribute = attribute.to_sym
      if back_end = options.delete(:back_end)
        @back_end = Maintain::Backend.build(back_end)
      end
      options.each do |key, value|
        self.send(key, value)
      end
    end

    def integer(value)
      @integer = !!value
    end

    def integer?
      !!@integer
    end

    def on(*args, &block)
      options = {when: :before}.merge(args.last.is_a?(Hash) ? args.pop : {})
      event, state = args.shift, args.shift
      method = args.shift
      if block_given?
        method = block
      end
      if back_end && back_end.respond_to?(:on)
        back_end.on(maintainee, @attribute, event, state, method, options)
      else
        hooks[state.to_sym] ||= {}
        hooks[state.to_sym][event.to_sym] ||= []
        method_hash = {method: method}.merge(options)
        if old_definition = hooks[state.to_sym][event.to_sym].find{|hook| hook[:method] == method}
          old_definition.merge!(method_hash)
        else
          hooks[state.to_sym][event.to_sym].push(method_hash)
        end
      end
    end

    def state_name_for(value)
      if value = states.find {|key, options| options[:compare_value] == value}
        value[0]
      end
    end

    def state(name, value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end
      @increment ||= 0
      if bitmask?
        unless value.is_a?(Integer)
          value = @increment
        end
        value = 2 ** value.to_i
      elsif value.is_a?(Integer)
        integer(true)
      end
      value ||= name
      states[name] = {compare_value: !bitmask? && value.is_a?(Integer) ? value : @increment, value: value}
      @increment += 1
      if back_end
        back_end.state maintainee, name, @attribute, value.is_a?(Symbol) ? value.to_s : value, force: options[:force]
      end

      # We need the states hash to contain the compare_value for this guy
      # before we can set defaults on the bitmask, since the default should
      # actually be a bitmask of all possible default states
      if options.has_key?(:default)
        default(name)
      end

      if options.has_key?(:enter)
        on :enter, name.to_sym, options.delete(:enter)
      end

      if options.has_key?(:exit)
        on :exit, name.to_sym, options.delete(:exit)
      end

      # Now we're going tests for state. Shortcuts to these methods only get
      # added if a method of their name doesn't already exist.
      boolean_method = "#{name}?"
      shortcut = options[:force] || method_free?(boolean_method)
      maintainee.class_eval <<-EOC
        def #{@attribute}_#{boolean_method}
          #{@attribute} == #{value.inspect}
        end
        #{"alias :#{boolean_method} :#{@attribute}_#{boolean_method}" if shortcut}
      EOC

      # Last but not least, add bang methods to automatically convert to state.
      # Like boolean methods above, these only get added if they're not already
      # things that are things.
      bang_method = "#{name}!"
      shortcut = options[:force] || method_free?(bang_method)
      maintainee.class_eval <<-EOC
        def #{@attribute}_#{bang_method}
          self.#{@attribute} = #{value.inspect}
        end
        #{"alias :#{bang_method} :#{@attribute}_#{bang_method}" if shortcut}
      EOC
    end

    def states
      @states ||= {}
    end

    def value(instance, initial = nil)
      if back_end
        initial = back_end.read(instance, @attribute)
      end
      initial ||= initial || @default
      if bitmask?
        BitmaskValue.new(self, initial || 0)
      elsif integer?
        IntegerValue.new(self, initial)
      else
        Value.new(self, initial)
      end
    end

    protected
    def hooks
      @hooks ||= {}
    end

    def maintainee
      @maintainee.split('::').inject(Object) {|mod, const| mod.const_get(const) }
    end

    def method_free?(method_name, class_method = false)
      # Ugly hack so we don't fetch it 100 times for no reason
      maintainee_class = maintainee
      if class_method
        return false if maintainee_class.respond_to?(method_name)
        methods = maintainee_class.public_methods
        methods += maintainee_class.private_methods
        methods += maintainee_class.protected_methods
      else
        methods = maintainee_class.instance_methods
      end
      !methods.include?(method_name.to_sym)
    end

    def method_missing(method, *args)
      if states.has_key?(method)
        states[method][:value]
      else
        super
      end
    end

    private
    def call_method_or_proc(method, instance)
      self.class.call_method_or_proc(method, instance)
    end
  end
end
