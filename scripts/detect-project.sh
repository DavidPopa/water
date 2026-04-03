#!/bin/bash
# =============================================================================
# Dragoon Setup 2.0 — Tech Stack Detector
#
# Usage: ./detect-project.sh [project-path]   # Defaults to current directory
#
# Output: KEY: value pairs (one per line, empty fields omitted)
# =============================================================================

set -o pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || { echo "ERROR: Directory not found: ${1:-.}" >&2; exit 1; }

# --- Helpers ---
has_file() { [ -f "${PROJECT_DIR}/$1" ]; }
has_dir()  { [ -d "${PROJECT_DIR}/$1" ]; }
emit()     { [ -n "$2" ] && echo "$1: $2"; }

# Join array items with commas (handles empty arrays safely)
join_arr() { local IFS=','; echo "$*"; }

pkg_has_dep() {
    local pkg="${PROJECT_DIR}/package.json"
    [ -f "$pkg" ] || return 1
    if command -v jq &>/dev/null; then
        jq -e "(.dependencies[\"$1\"] // .devDependencies[\"$1\"] // .peerDependencies[\"$1\"]) != null" "$pkg" &>/dev/null
    else
        grep -q "\"$1\"" "$pkg" 2>/dev/null
    fi
}

pkg_has_script() {
    local pkg="${PROJECT_DIR}/package.json"
    [ -f "$pkg" ] || return 1
    if command -v jq &>/dev/null; then
        jq -e ".scripts[\"$1\"] != null" "$pkg" &>/dev/null
    else
        grep -q "\"$1\"" "$pkg" 2>/dev/null
    fi
}

pyfile_has() {
    grep -ql "$1" "${PROJECT_DIR}/requirements.txt" "${PROJECT_DIR}/pyproject.toml" 2>/dev/null
}

# --- Detectors ---
detect_language() {
    local r=""
    has_file "tsconfig.json" && r="${r:+$r,}typescript"
    has_file "package.json" && ! has_file "tsconfig.json" && r="${r:+$r,}javascript"
    { has_file "requirements.txt" || has_file "pyproject.toml" || has_file "setup.py"; } && r="${r:+$r,}python"
    has_file "go.mod"       && r="${r:+$r,}go"
    has_file "Cargo.toml"   && r="${r:+$r,}rust"
    { has_file "pom.xml" || has_file "build.gradle" || has_file "build.gradle.kts"; } && r="${r:+$r,}java"
    has_file "Gemfile"      && r="${r:+$r,}ruby"
    has_file "mix.exs"      && r="${r:+$r,}elixir"
    has_file "Package.swift" && r="${r:+$r,}swift"
    echo "$r"
}

detect_framework() {
    if has_file "package.json"; then
        pkg_has_dep "next"          && echo "nextjs"   && return
        pkg_has_dep "nuxt"          && echo "nuxt"     && return
        pkg_has_dep "@angular/core" && echo "angular"  && return
        pkg_has_dep "svelte"        && echo "svelte"   && return
        pkg_has_dep "react"         && echo "react"    && return
        pkg_has_dep "vue"           && echo "vue"      && return
        pkg_has_dep "express"       && echo "express"  && return
        pkg_has_dep "fastify"       && echo "fastify"  && return
        pkg_has_dep "hono"          && echo "hono"     && return
        pkg_has_dep "@nestjs/core"  && echo "nestjs"   && return
    fi
    if has_file "requirements.txt" || has_file "pyproject.toml"; then
        pyfile_has "fastapi"   && echo "fastapi"   && return
        pyfile_has "django"    && echo "django"    && return
        pyfile_has "flask"     && echo "flask"     && return
    fi
    if has_file "go.mod"; then
        grep -q "gin-gonic"     "${PROJECT_DIR}/go.mod" 2>/dev/null && echo "gin"   && return
        grep -q "labstack/echo" "${PROJECT_DIR}/go.mod" 2>/dev/null && echo "echo"  && return
        grep -q "go-chi"        "${PROJECT_DIR}/go.mod" 2>/dev/null && echo "chi"   && return
    fi
    if has_file "Cargo.toml"; then
        grep -q "axum"      "${PROJECT_DIR}/Cargo.toml" 2>/dev/null && echo "axum"   && return
        grep -q "actix-web" "${PROJECT_DIR}/Cargo.toml" 2>/dev/null && echo "actix"  && return
        grep -q "rocket"    "${PROJECT_DIR}/Cargo.toml" 2>/dev/null && echo "rocket" && return
    fi
    if has_file "Gemfile"; then
        grep -q "rails"   "${PROJECT_DIR}/Gemfile" 2>/dev/null && echo "rails"   && return
        grep -q "sinatra" "${PROJECT_DIR}/Gemfile" 2>/dev/null && echo "sinatra" && return
    fi
}

detect_package_manager() {
    { has_file "bun.lockb" || has_file "bun.lock"; }  && echo "bun"    && return
    has_file "pnpm-lock.yaml"                          && echo "pnpm"   && return
    has_file "yarn.lock"                               && echo "yarn"   && return
    has_file "package-lock.json"                       && echo "npm"    && return
    has_file "package.json"                            && echo "npm"    && return
    has_file "poetry.lock"                             && echo "poetry" && return
    has_file "uv.lock"                                 && echo "uv"    && return
    has_file "Pipfile"                                 && echo "pipenv" && return
    { has_file "requirements.txt" || has_file "pyproject.toml"; } && echo "pip" && return
    has_file "go.mod"                                  && echo "go-modules" && return
    has_file "Cargo.toml"                              && echo "cargo"  && return
    has_file "Gemfile"                                 && echo "bundler" && return
}

detect_test_framework() {
    if has_file "package.json"; then
        { has_file "vitest.config.ts" || has_file "vitest.config.js" || pkg_has_dep "vitest"; } && echo "vitest" && return
        { has_file "jest.config.js" || has_file "jest.config.ts" || pkg_has_dep "jest"; }       && echo "jest"   && return
        pkg_has_dep "mocha"            && echo "mocha"      && return
        pkg_has_dep "@playwright/test" && echo "playwright" && return
        pkg_has_dep "cypress"          && echo "cypress"    && return
    fi
    { has_file "pytest.ini" || has_file "conftest.py"; } && echo "pytest" && return
    pyfile_has "pytest" && echo "pytest" && return
    has_file "go.mod"      && echo "go-test"    && return
    has_file "Cargo.toml"  && echo "cargo-test" && return
    has_file "Gemfile" && grep -q "rspec" "${PROJECT_DIR}/Gemfile" 2>/dev/null && echo "rspec" && return
}

detect_linter() {
    local r=""
    { has_file ".eslintrc" || has_file ".eslintrc.js" || has_file ".eslintrc.json" || has_file "eslint.config.js" || has_file "eslint.config.mjs"; } && r="${r:+$r,}eslint"
    { has_file ".prettierrc" || has_file ".prettierrc.json" || has_file "prettier.config.js"; } && r="${r:+$r,}prettier"
    { has_file "biome.json" || has_file "biome.jsonc"; } && r="${r:+$r,}biome"
    { has_file "ruff.toml" || has_file ".ruff.toml"; } && r="${r:+$r,}ruff"
    has_file "pyproject.toml" && grep -q "\[tool.ruff\]"  "${PROJECT_DIR}/pyproject.toml" 2>/dev/null && r="${r:+$r,}ruff"
    has_file "pyproject.toml" && grep -q "\[tool.black\]" "${PROJECT_DIR}/pyproject.toml" 2>/dev/null && r="${r:+$r,}black"
    has_file "pyproject.toml" && grep -q "\[tool.mypy\]"  "${PROJECT_DIR}/pyproject.toml" 2>/dev/null && r="${r:+$r,}mypy"
    has_file ".flake8" && r="${r:+$r,}flake8"
    { has_file ".golangci.yml" || has_file ".golangci.yaml"; } && r="${r:+$r,}golangci-lint"
    has_file "Cargo.toml"  && r="${r:+$r,}clippy"
    has_file ".rubocop.yml" && r="${r:+$r,}rubocop"
    # Deduplicate
    echo "$r" | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//'
}

detect_build_cmd() {
    has_file "package.json" && pkg_has_script "build" && echo "npm run build" && return
    has_file "Makefile" && grep -q "^build:" "${PROJECT_DIR}/Makefile" 2>/dev/null && echo "make build" && return
    has_file "go.mod"     && echo "go build ./..." && return
    has_file "Cargo.toml" && echo "cargo build"    && return
}

detect_test_cmd() {
    has_file "package.json" && pkg_has_script "test" && echo "npm test" && return
    has_file "Makefile" && grep -q "^test:" "${PROJECT_DIR}/Makefile" 2>/dev/null && echo "make test" && return
    has_file "go.mod"     && echo "go test ./..." && return
    has_file "Cargo.toml" && echo "cargo test"    && return
    { has_file "pytest.ini" || has_file "conftest.py"; } && echo "pytest" && return
    pyfile_has "pytest" && echo "pytest" && return
}

detect_lint_cmd() {
    has_file "package.json" && pkg_has_script "lint" && echo "npm run lint" && return
    { has_file "eslint.config.js" || has_file "eslint.config.mjs" || has_file ".eslintrc.js" || has_file ".eslintrc.json"; } && echo "npx eslint ." && return
    has_file "biome.json" && echo "npx biome check ." && return
    { has_file "ruff.toml" || has_file ".ruff.toml"; } && echo "ruff check ." && return
    has_file "pyproject.toml" && grep -q "\[tool.ruff\]" "${PROJECT_DIR}/pyproject.toml" 2>/dev/null && echo "ruff check ." && return
    { has_file ".golangci.yml" || has_file ".golangci.yaml"; } && echo "golangci-lint run" && return
    has_file "Cargo.toml"  && echo "cargo clippy" && return
    has_file ".rubocop.yml" && echo "rubocop"     && return
}

detect_architecture() {
    if has_file "package.json" && command -v jq &>/dev/null; then
        jq -e '.workspaces != null' "${PROJECT_DIR}/package.json" &>/dev/null && echo "monorepo" && return
    fi
    has_file "lerna.json"          && echo "monorepo"   && return
    has_file "pnpm-workspace.yaml" && echo "monorepo"   && return
    has_file "nx.json"             && echo "monorepo"   && return
    has_file "turbo.json"          && echo "monorepo"   && return
    { has_file "serverless.yml" || has_file "serverless.yaml"; } && echo "serverless" && return
    { has_file "next.config.js" || has_file "next.config.mjs" || has_file "next.config.ts"; } && echo "fullstack" && return
    echo "monolith"
}

detect_ci_cd() {
    local r=""
    has_dir ".github/workflows"      && r="${r:+$r,}github-actions"
    has_file ".gitlab-ci.yml"        && r="${r:+$r,}gitlab-ci"
    has_file "Jenkinsfile"           && r="${r:+$r,}jenkins"
    has_file ".circleci/config.yml"  && r="${r:+$r,}circleci"
    has_file ".travis.yml"          && r="${r:+$r,}travis"
    has_file "vercel.json"           && r="${r:+$r,}vercel"
    has_file "netlify.toml"          && r="${r:+$r,}netlify"
    has_file "fly.toml"              && r="${r:+$r,}fly-io"
    echo "$r"
}

detect_database() {
    local r=""
    has_dir "prisma" && r="${r:+$r,}prisma"
    if has_file "package.json"; then
        { pkg_has_dep "pg" || pkg_has_dep "@prisma/client"; } && r="${r:+$r,}postgresql"
        { pkg_has_dep "mysql2" || pkg_has_dep "mysql"; }      && r="${r:+$r,}mysql"
        { pkg_has_dep "mongodb" || pkg_has_dep "mongoose"; }  && r="${r:+$r,}mongodb"
        { pkg_has_dep "better-sqlite3" || pkg_has_dep "sqlite3"; } && r="${r:+$r,}sqlite"
        { pkg_has_dep "redis" || pkg_has_dep "ioredis"; }     && r="${r:+$r,}redis"
    fi
    if has_file "requirements.txt"; then
        grep -qi "psycopg\|sqlalchemy" "${PROJECT_DIR}/requirements.txt" 2>/dev/null && r="${r:+$r,}postgresql"
        grep -qi "pymongo" "${PROJECT_DIR}/requirements.txt" 2>/dev/null && r="${r:+$r,}mongodb"
    fi
    echo "$r"
}

# --- Output ---
emit "LANGUAGE"        "$(detect_language || true)"
emit "FRAMEWORK"       "$(detect_framework || true)"
emit "PACKAGE_MANAGER" "$(detect_package_manager || true)"
emit "TEST_FRAMEWORK"  "$(detect_test_framework || true)"
emit "LINTER"          "$(detect_linter || true)"
emit "DATABASE"        "$(detect_database || true)"
emit "BUILD_CMD"       "$(detect_build_cmd || true)"
emit "TEST_CMD"        "$(detect_test_cmd || true)"
emit "LINT_CMD"        "$(detect_lint_cmd || true)"
emit "ARCHITECTURE"    "$(detect_architecture || true)"
emit "CI_CD"           "$(detect_ci_cd || true)"

exit 0
