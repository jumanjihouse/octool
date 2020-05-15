# OCTool

<!--TOC-->

- [Overview](#overview)
- [How-to](#how-to)
  - [Get started with an example](#get-started-with-an-example)
  - [Prereqs](#prereqs)
  - [Install OCTool](#install-octool)
  - [Generate an SSP from the example data](#generate-an-ssp-from-the-example-data)
  - [Explore the schema for data inputs](#explore-the-schema-for-data-inputs)
- [Concepts](#concepts)
  - [Entities](#entities)
  - [System vs component](#system-vs-component)
  - [Benefits](#benefits)
- [Administrivia](#administrivia)
  - [Goals](#goals)

<!--TOC-->

## Overview

OCTool aspires to be an open compliance tool and library.


## How-to

### Get started with an example

This repo provides an example tree at `example-inputs/minimal`.


### Prereqs

Your host needs these packages:

- Ruby
- Pandoc 2.9+
- TexLive full distribution, including LuaTeX


### Install OCTool

```bash
gem install --user-install octool
```

### Generate an SSP from the example data

1. Confirm the example data is valid

    ```bash
    octool validate data example-inputs/minimal/config.yaml
    ```

1. Build a PDF

    ```bash
    octool ssp example-inputs/minimal/config.yaml
    ```

1. The result should look like the example output at
   [example-outputs/minimal/ssp.pdf](example-outputs/minimal/ssp.pdf).


### Explore the schema for data inputs

The schemas are at [src/schemas/](src/schemas).<br/>
Things to know:

- All text strings are interpreted as markdown.<br/>
  You can use markdown in your data anywhere a string is required.<br/>
  See [example-inputs/minimal](example-inputs/minimal) for demo data.

  :eyes: Pandoc has its own flavor of markdown. See
  [https://pandoc.org/MANUAL.html#pandocs-markdown](https://pandoc.org/MANUAL.html#pandocs-markdown)
  for differences from other flavors.

- You can run `octool validate data path/to/inputs` to confirm your data
  structure.

- Do you want to run `octool` in a read-only container?<br/>
  TeX needs to write to at least one directory.<br/>
  Make at least one of these a volume in your container:

  - `${HOME}` or
  - `/usr/share/texmf-var` on Alpine Linux and probably others


## Concepts

### Entities

This diagram helps to illustrate the definitions that follow.<br/>
It reads top-down and left-to-right.

![](assets/er.png)

- **System**: A potentially-complex technology architecture that
  includes one or more components.

- **ConfigFile**: An OCTool configuration file.

- **Component**: A list of components within the system along with
  attestations to satisfy one or more controls.

- **Standard**: A list that defines one or more security controls.

    An example of a standard is NIST 800-53 or Payment
    Card Industry Data Security Standards (PCI DSS).

- **Control**: A specific requirement or process to describe and mitigate risk.

- **Certification**: A list that requires one or more controls.

    A certification requires all or a subset of controls
    from one or more standards.<br/>
    A hypothetical certification could include
    all of NIST 800-53 _plus_ a specific subset of PCI DSS.

    An Authority to Operate (ATO) is one example of a certification.
    A request list from an auditor is another example.


### System vs component

A component and a system can be identical from a compliance perspective
in the simplest cases. It is common, however, that a complex system
delegates compliance to multiple responsible parties
along organizational boundaries in a _shared services_ model.

Consider, for example, an organization that owns its datacenter and
assigns responsibility for physical access to a dedicated team.

- The organization can describe the datacenter as a component and
  describe its compliance to physical access controls
  within a shareable component called _datacenter_.

- Teams that operate software within the datacenter can then
  include the _datacenter_ component
  within their own compliance documentation.

With the shared services model, the _system_ compliance documentation
_includes_ various components. Its compliance documentation is
assembled from various components.

Thus some systems are described by multiple components;
smaller systems, by a single component.


### Benefits

- If an application owner requests an exception to a control from a
  shared component, the InfoSec team can run an impact assessment
  to see which other applications (systems) and/or certifications
  would be impacted by the exception.

- The organization can use the system to ask what-if questions.

- Compliance and regulatory teams have a central source of truth
  from which to answer questions.

- Git provides an audit log of changes to the compliance docs.

- The intermediate output (SQL database, CSV, etc.) is available
  so teams can choose whatever analytical tools they prefer.


## Administrivia

### Goals

- [X] Read input configuration in multiple formats
- [X] Generate output documentation for governance and compliance
  - [ ] Excel
  - [X] Markdown
  - [X] PDF
  - [ ] Word
- [ ] Convert inputs to a well-defined data structure
  - Intermediate output
    - [ ] CSV
    - [ ] Excel
    - [ ] SQLite
  - Facilitate gap analysis
  - Facilitate impact analysis for exceptions
