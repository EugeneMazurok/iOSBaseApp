 #!/usr/bin/env bash

install_utils() {
     gem install bundler
     if [[ $is_ci == true ]]; then bundle config set --local deployment 'true'; fi
     if [[ $is_ci == true ]]; then bundle lock --add-platform x86_64-darwin-19; fi
     bundle install
     gem install cocoapods
     brew install xcodegen
     brew install XCTestHtmlReport/xchtmlreport/xchtmlreport
     # На сиайке стоит Catalina => Xcode 12.4 => нельзя установить свежий Swiftlint
     if (( brew ls --versions swiftlint > /dev/null ) && ( $is_ci == true )); then
     echo "Swiftlint is already installed. "
     else
     brew install swiftlint
     fi
     exit 0
}

IS_CI=false

if [ $# -eq 0 ]; then
    install_utils
fi

for arg in "$@"; do
    case $arg in
    --ci)
        IS_CI=true
        install_utils
        shift
        ;;
    *)
        echo "wrong parameter"
        exit 1
        ;;
    esac
done
