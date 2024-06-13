.NOTPARALLEL, .SILENT:

# Project constants
global_project_name = BaseGalleryProject
global_project_bundle_id = com.baseapp

old_bundle_id = $(global_project_bundle_id)
new_bundle_id = com.baseapp

old_name = $(global_project_name)
new_name = BaseApp

old_name_lower = $(shell echo $(old_name) | tr '[:upper:]' '[:lower:]')
new_name_lower = $(shell echo $(new_name) | tr '[:upper:]' '[:lower:]')

is_ci = false

project:
	git submodule init
	git submodule update
	git submodule foreach 'git reset --hard && git checkout master && git pull --ff-only'
	xcodegen
	pod install --repo-update
	if [ $(is_ci) == false ]; then open $(global_project_name).xcworkspace; fi

configs:
	open Config/AppIdentifiers.xcconfig

change_bundle_id:
	pod deintegrate
	rm -rf "$(old_name).xcodeproj" 
	rm -rf "$(old_name).xcworkspace" 
	LC_ALL=C find . -type f -name '*.yml' -exec sed -i '' s/$(old_bundle_id)/$(new_bundle_id)/g {} +
	LC_ALL=C find . -type f -name '*.xcconfig' -exec sed -i '' s/$(old_bundle_id)/$(new_bundle_id)/g {} +
	xcodegen
	pod install
	sed -i '' s/"global_project_bundle_id = "$(global_project_bundle_id)/"global_project_bundle_id = $(new_bundle_id)"/g Makefile
	echo "$$SUCCESS_BANNER"
	exit 0

rename_project:
	 xcodegen
	 pod deintegrate
	 rm -rf $(old_name).xcodeproj 
	 rm -rf $(old_name).xcworkspace 
	 rm -rf Podfile.lock 
	 LC_ALL=C find . -type f -name '*.yml' -exec sed -i '' s/$(old_name)/$(new_name)/g {} +
	 LC_ALL=C find . -type f -name '*.xcconfig' -exec sed -i '' s/$(old_name)/$(new_name)/g {} +
	 LC_ALL=C find . -type f -name '*.yml' -exec sed -i '' s/$(old_name_lower)/$(new_name_lower)/g {} +
	 LC_ALL=C find . -type f -name '*.xcconfig' -exec sed -i '' s/$(old_name_lower)/$(new_name_lower)/g {} +
	 LC_ALL=C find . -type f -name '*.entitlements' -exec sed -i '' s/$(old_name)/$(new_name)/g {} +
	 sed -i '' s/$(old_name)/$(new_name)/g Podfile
	 sed -i '' s/$(old_name_lower)/$(new_name_lower)/g Podfile
	 mv $(old_name) $(new_name)
	 xcodegen
	 pod install
	 sed -i '' s/"global_project_name = "$(global_project_name)/"global_project_name = $(new_name)"/g Makefile
	 sed -i '' s/"global_project_bundle_id = "$(global_project_bundle_id)/"global_project_bundle_id = $(subst $(old_name_lower),$(new_name_lower),$(global_project_bundle_id))"/g Makefile
	 echo "$$SUCCESS_BANNER"
	 exit 0

utils:
	 if [ $(is_ci) == true ]; then \
	 ./build-scripts/utilities/install_utilities.sh --ci; \
	 else \
	 ./build-scripts/utilities/install_utilities.sh; \
	 fi


define SUCCESS_BANNER
       
           .--.                  Проект не засрать
 ::\`--._,'.::.`._.--'/::           постарайся.
 ::::.  ` __::__ '  .::::    Техлид благословляет тебя.
 ::::::-:.`'..`'.:-::::::
 ::::::::\ `--' /::::::::              - Cheeezcake
       
endef
export SUCCESS_BANNER

define ERROR_BANNER
       
           .--.               team_confidential.yml забыл ты
 ::\`--._,'.::.`._.--'/::         положить в /fastlane/,
 ::::.  ` __::__ '  .::::             дурень.
 ::::::-:.`'..`'.:-::::::
 ::::::::\ `--' /::::::::              - Cheeezcake
       
endef
export ERROR_BANNER

RESET=tput sgr0
GREEN=tput setaf 2
RED=tput setaf 1
