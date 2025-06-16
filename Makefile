GENHTML=C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml
LCOV=C:\ProgramData\chocolatey\lib\lcov\tools\bin\lcov

## Setup Commands ----------------------------------------

## Note: In windows, recommended terminal is cmd 

ensure_flutter_version: ## Ensures flutter version is 3.32.4 
	fvm install 3.32.4
	fvm use 3.32.4
	fvm global 3.32.4

## Note: If you are using a specific flutter version, change '3.32.4' to the desired '{flutter version}' you want to use

clean: ## Delete the build/ and .dart_tool/ directories
	fvm flutter clean
	
pub_clean: ## Empties the entire system cache to reclaim extra disk space or remove problematic packages
	fvm flutter pub cache clean	

pub_get: ## Gets pubs
	fvm flutter pub get

pub_outdated: ## Check for outdated packages
	fvm flutter pub outdated

pub_upgrade: ## Upgrade the current package's dependencies to latest versions
	fvm flutter pub upgrade

pub_repair: ## Performs a clean reinstallation of all packages in your system cache
	fvm flutter pub cache repair

format: ## This command formats the codebase and run import sorter
	fvm dart format lib test

clean_rebuild: ensure_flutter_version clean pub_clean pub_get format lint fix_lint 

rebuild: ensure_flutter_version pub_get format lint fix_lint 

lint: ## Analyzes the codebase for issues
	fvm flutter analyze lib test
	fvm dart analyze lib test

fix_lint: ## Fixes lint issues
	fvm dart fix --apply

test_publish:
	dart pub publish --dry-run

publish:
	dart pub publish
