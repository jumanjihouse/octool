module OCTool
    LATEST_SCHEMA_VERSION = 'v1.0.0'.freeze
    BASE_SCHEMA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'schemas').freeze
    ERB_DIR = File.join(File.dirname(__FILE__), '..', '..', 'templates').freeze
    DEFAULT_CONFIG_FILENAME = 'config.yaml'.freeze
end
