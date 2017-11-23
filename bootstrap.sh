#!/usr/bin/env bash
set -euo pipefail

echo "Node version: $(node --version)"
echo "Yarn version: $(yarn --version)"

echo -n "Proceed? (yes/no) "
read proceed

if [ "$proceed" != "yes" ]; then
  echo "Stopping."
  exit 0
fi

echo "Installing packages..."
yarn init --yes
yarn add --dev typescript tslint @types/node

binDir="./node_modules/.bin"

echo "Initializing project..."
"${binDir}/tsc" --init --target ES2017
"${binDir}/tslint" --init

cat > ".gitignore" << EOM
bootstrap.sh
node_modules/
*.js
EOM

cat > "index.ts" << EOM
EOM

mkdir -p ".vscode"
cat > ".vscode/settings.json" << EOM
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "tslint.alwaysShowRuleFailuresAsWarnings": true
}
EOM

echo "Initializing Git repository"
if [ -d .git ]; then
  echo "A Git repository already exists. Skipping."
else
  git init
  git add .
  git commit -m "Create new TypeScript + Node project"
fi;

echo "Opening VSCode"
code . index.ts
