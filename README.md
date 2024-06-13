# BaseApp
Базовый шаблон для будущих iOS-приложений, содержащий основные функции: навигацию, логин и регистрацию, и утилитарные полезные плюшки в виде кастомных вьюшек, расширений UIKit классов и остального

# Установка и создание нового проекта
````
          .--.                  Да прибудет с тобой сила,
::\`--._,'.::.`._.--'/::           разработчик.
::::.  ` __::__ '  .::::    Техлид благословляет тебя.
::::::-:.`'..`'.:-::::::
::::::::\ `--' /::::::::              - Cheeezcake
````
## Кодогенерация в проекте
Отныне в проекте используется xcodegen, который сам генерирует файл проекта. 

**Для сохранения настроек их необходимо прописывать в соответствующих .xcconfig и .yml файлах.**

Для быстрого старта нового проекта и легкой развертки существующего, отпочковавшегося от текущей версии бейзапы, был реализован ряд команд, автоматизирующих определенные процессы:
1. ### ```git init```

2. ### Инициализация после git clone/git pull
```make project``` - запускает сценарий генерации всего, чего нужно и подтягивает сертификаты и профили из репозитория.

3. ### Переименование для старта нового проекта
```make rename_project new_name=НовоеИмяПроекта``` - удалит все лишнее, переименует все нужное (включая bundle id), сгенерит заново файл проекта и поставит поды.

Запускаем ```.xcworkspace``` файл и вперед к новым вершинам 🤘

# Важно
- Для разрабов с машинами на Apple Silicon и юзающих ```brew``` добавить строку в SwiftLint Build Phase: ```export PATH="$PATH:/opt/homebrew/bin"```. Также там же очевидно поменять дефолтный shell на свой.
- Для них же, я изменил ```post_install``` в ```podfile```, однако, если у вас вознкиают какие-то ошибки, можно попробовать вернуть оригинальный ```post_install```:
````
post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        config.build_settings['LD_NO_PIE'] = 'NO'
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
          config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
                '$(FRAMEWORK_SEARCH_PATHS)'
              ]
        end
      end
    end
  end
````

