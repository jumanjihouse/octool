# frozen_string_literal: true

module OCTool
    LATEST_SCHEMA_VERSION = 'v1.0.0'
    BASE_SCHEMA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'schemas').freeze
    ERB_DIR = File.join(File.dirname(__FILE__), '..', '..', 'templates').freeze
    DEFAULT_CONFIG_FILENAME = 'config.yaml'
    DEFAULT_OUTPUT_DIR = '/data'
end
