# Inclusive naming action

A github action that checks code for non-inclusive language and makes suggestions on alternate language.

## Installation

To use this check on your project add following action to your `/.github/workflows`:

```

name: Inclusive naming PR check
on: pull_request

jobs:
  call-inclusive-naming-check:
    name: Inclusive naming check
    uses: canonical-web-and-design/Inclusive-naming/.github/workflows/woke.yaml@main
    with:
      fail-on-error: "true"

```
## Configuration

The words that are flagged by the action and their corresponding alternatives can be found in the `config.yml` file. To add a word, find the appropriate section (or create a new one if needed) and add the the word to be flagged and suggested alternatives in the following style:

```

  - name: whitelist
    terms:
      - whitelist
      - white-list
    alternatives:
      - allowlist
    severity: error

```

*Right now all words severity is being set to 'error'*
