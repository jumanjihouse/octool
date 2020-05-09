erDiagram
    SYSTEM ||--|| CONFIGFILE : "described by"
    CONFIGFILE }o--o{ STANDARD : includes
    CONFIGFILE }o--o{ CERTIFICATION : includes
    CONFIGFILE }o--o{ COMPONENT : includes
    STANDARD ||--|{ CONTROL : defines
    CERTIFICATION }o--|{ CONTROL : requires
    COMPONENT }o--|{ ATTESTATION : attests
    ATTESTATION }o--|{ CONTROL : satisfies
