#!/usr/bin/env bash

OLD_VERSION=$1
if [[ -z "$OLD_VERSION" ]]; then
  echo "Usage: version.sh old new"
  exit 1
fi

NEW_VERSION=$2
if [[ -z "$NEW_VERSION" ]]; then
  echo "Usage: version.sh old new"
  exit 1
fi

set_version () {
  sed -i "s_\"version\": \"$OLD_VERSION\"_\"version\": \"$NEW_VERSION\"_g" $1
  sed -i "s_\"@medplum/definitions\": \"$OLD_VERSION\"_\"@medplum/definitions\": \"$NEW_VERSION\"_g" $1
  sed -i "s_\"@medplum/core\": \"$OLD_VERSION\"_\"@medplum/core\": \"$NEW_VERSION\"_g" $1
  sed -i "s_\"@medplum/ui\": \"$OLD_VERSION\"_\"@medplum/ui\": \"$NEW_VERSION\"_g" $1
}

# Update package.json files
set_version "packages/app/package.json"
set_version "packages/core/package.json"
set_version "packages/definitions/package.json"
set_version "packages/generator/package.json"
set_version "packages/graphiql/package.json"
set_version "packages/infra/package.json"
set_version "packages/server/package.json"
set_version "packages/ui/package.json"

# Update sonar-project.properties
sed -i "s/sonar.projectVersion=$OLD_VERSION/sonar.projectVersion=$NEW_VERSION/g" "sonar-project.properties"

# Update deploy-server.sh
sed -i "s/medplum-server:$OLD_VERSION/medplum-server:$NEW_VERSION/g" "scripts/deploy-server.sh"

# Then update node_modules and package-lock.json
npm i --legacy-peer-deps