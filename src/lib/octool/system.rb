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
            @certifications ||= @data.select { |e| e.is_a?(OCTool::Certification) }
        end

        def components
            @components ||= @data.select { |e| e.is_a?(OCTool::Component) }
        end

        def standards
            @standards ||= @data.select { |e| e.is_a?(OCTool::Standard) }
        end

        # List of all attestations claimed by components in the system.
        def attestations
            @attestations ||= begin
                @attestations = []
                components.each do |c|
                    # Add a "component_key" field to each attestation.
                    c.attestations.map! { |e| e['component_key'] = c.component_key; e }
                    @attestations << c.attestations
                end
                @attestations.flatten!
            end
        end

        # List of all coverages.
        def satisfies
            @satisfies ||= begin
                @satisfies = []
                attestations.each do |a|
                    # Add an "attestation_key" field to each cover.
                    a.satisfies.map! { |e| e['component_key'] = a.commponent_key; e }
                    a.satisfies.map! { |e| e['attestation_key'] = a.attestation_summary; e }
                    @satisfies << a.satisfies
                end
                @satisfies.flatten!
            end
        end

        # List of all controls defined by standards in the system.
        def controls
            @controls || begin
                @controls = []
                standards.each do |s|
                    # Add a "standard_key" field to each control.
                    s.controls.map! { |e| e['standard_key'] = s.standard_key; e }
                    @controls << s.controls
                end
                @controls.flatten!
            end
        end

        # List of all families defined by standards in the system.
        def families
            @families || begin
                @families = []
                standards.each do |s|
                    # Add a "standard_key" field to each family.
                    s.families.map! { |e| e['standard_key'] = s.standard_key; e }
                    @families << s.families
                end
                @families.flatten!
            end
        end
    end
end
