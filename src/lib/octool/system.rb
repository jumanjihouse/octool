# frozen_string_literal: true

module OCTool
    # Representation of a system
    class System
        attr_accessor :config
        attr_accessor :data

        def initialize(config)
            @config = config
            @data = []
        end

        def certifications
            @certifications ||= data.select { |e| e.type == 'certification' }
        end

        def components
            @components ||= data.select { |e| e.type == 'component' }
        end

        def standards
            @standards ||= data.select { |e| e.type == 'standard' }
        end

        # List of all attestations claimed by components in the system.
        def attestations
            @attestations ||= components.map(&:attestations).flatten
        end

        # List of all coverages.
        def satisfies
            @satisfies ||= attestations.map(&:satisfies).flatten
        end

        # List of all controls defined by standards in the system.
        def controls
            @controls ||= standards.map(&:controls).flatten
        end

        # List of all families defined by standards in the system.
        def families
            @families ||= standards.map(&:families).flatten
        end

        # List of required controls for all certifications.
        def requires
            @requires ||= certifications.map(&:requires).flatten
        end
    end
end
