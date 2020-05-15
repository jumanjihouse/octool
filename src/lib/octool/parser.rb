# frozen_string_literal: true

module OCTool
    # Custom error to show validation errors.
    class ValidationError < StandardError
        attr_reader :errors
        def initialize(path, errors)
            @path = path
            @errors = errors
        end

        def message
            msg = ["[ERROR] #{@path}"]
            @errors.each do |e|
                msg << "line #{e.linenum} col #{e.column} [#{e.path}] #{e.message}"
            end
            msg.join("\n")
        end
    end

    # Logic to wrap the kwalify parser.
    class Parser
        def initialize(path)
            @config_file = path
            die "#{File.expand_path(path)} not readable" unless File.readable?(path)
        end

        # Class method: check that schemas are valid.
        def self.validate_schemas
            metavalidator = Kwalify::MetaValidator.instance
            kwalify = Kwalify::Yaml::Parser.new(metavalidator)
            Dir.glob("#{BASE_SCHEMA_DIR}/**/*.yaml").each do |schema|
                kwalify.parse_file(schema)
            end
        end

        def die(message = nil)
            puts '[FAIL] ' + message if message
            exit(1)
        end

        def validate_file(path, type)
            parser = kwalify_parser(type)
            data = parser.parse_file(path)
            errors = parser.errors
            raise ValidationError.new(path, errors) unless errors.empty?

            data
        rescue SystemCallError, Kwalify::SyntaxError, ValidationError => e
            die e.message
        end

        def kwalify_parser(type)
            schema_file = File.join(schema_dir, "#{type}.yaml")
            schema = Kwalify::Yaml.load_file(schema_file)
            validator = Kwalify::Validator.new(schema)
            Kwalify::Yaml::Parser.new(validator) { |p| p.data_binding = true }
        end

        def schema_dir
            @schema_dir ||= File.join(BASE_SCHEMA_DIR, schema_version)
        end

        def schema_version
            @schema_version ||= Kwalify::Yaml.load_file(@config_file)['schema_version']
        rescue StandarError
            STDERR.puts '[FAIL] Unable to read schema_version'
            exit(1)
        end

        # Check that all data files are valid.
        def validate_data
            base_dir = File.dirname(@config_file)
            config = validate_file(@config_file, 'config')
            config['includes'].each do |inc|
                path = File.join(base_dir, inc['path'])
                type = inc['type']
                validate_file(path, type)
            end
            config
        end

        def load_system
            base_dir = File.dirname(@config_file)
            config = load_file(@config_file, 'config')
            system = System.new(config)
            config.includes.each do |inc|
                path = File.join(base_dir, inc.path)
                system.data << load_file(path, inc.type)
            end
            system
        end

        def load_file(path, type)
            die "#{File.expand_path(path)} not readable" unless File.readable?(path)
            klass = Object.const_get("OCTool::#{type.capitalize}")
            ydoc = Kwalify::Yaml.load_file(path)
            klass.new(ydoc)
        rescue SystemCallError, Kwalify::SyntaxError => e
            die e.message
        end
    end
end
