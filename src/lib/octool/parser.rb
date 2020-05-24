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
            kwal = kwalifyer(type)
            data = kwal.parse_file(path)
            data['type'] = type
            errors = kwal.errors
            raise ValidationError.new(path, errors) unless errors.empty?

            RecursiveOpenStruct.new(data, recurse_over_arrays: true, preserve_original_keys: true)
        rescue SystemCallError, Kwalify::SyntaxError, ValidationError => e
            die e.message
        end

        def kwalifyer(type)
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

        # Validate and load data in one pass.
        def validate_data
            base_dir = File.dirname(@config_file)
            config = validate_file(@config_file, 'config')
            sys = System.new(config)
            config['includes'].each do |inc|
                path = File.join(base_dir, inc['path'])
                sys.data << validate_file(path, inc['type'])
            end
            sys
        end

        alias load_system validate_data
        alias load_file validate_file
    end
end
