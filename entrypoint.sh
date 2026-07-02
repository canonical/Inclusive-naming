
#!/bin/bash

set -e

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group:: Installing woke ... https://github.com/get-woke/woke'
curl -sfL https://raw.githubusercontent.com/get-woke/woke/main/install.sh | sh -s -- -b "${TEMP_PATH}" "${INPUT_WOKE_VERSION}" 2>&1
echo '::endgroup::'

FAIL_LEVEL_FLAG=""
if [ "${INPUT_FAIL_ON_ERROR:-false}" = "true" ]; then
  FAIL_LEVEL_FLAG="-fail-level=error"
fi

# Fallback to the action's internal config if no config flag is provided
if [[ ! "$INPUT_WOKE_ARGS" =~ "-c" ]] && [[ ! "$INPUT_WOKE_ARGS" =~ "--config" ]]; then
  INPUT_WOKE_ARGS="$INPUT_WOKE_ARGS -c $GITHUB_ACTION_PATH/config.yml"
fi

echo '::group::'
woke --output simple ${INPUT_WOKE_ARGS} \
  | reviewdog -efm="%f:%l:%c: %m" \
      -name="Inclusive naming check" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      ${FAIL_LEVEL_FLAG} \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
echo '::endgroup::'
