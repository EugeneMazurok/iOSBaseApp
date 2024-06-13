 #!/usr/bin/env bash

MATTERMOST_WEBHOOK_URL="https://mt.webant.ru/hooks/u65j49b8bfbn8qzo981dyeyhzr"
REPORT_FILE=public/${CI_PIPELINE_ID}/index.html

if [ -f "$REPORT_FILE" ]; then
    echo "WOOOO! Someone will be in trouble..."
  curl -X POST $MATTERMOST_WEBHOOK_URL -H 'Content-Type: application/json' -d @- <<EOF
    {
        "channel": "ios-linter-channel",
        "text": ":shipit: **${CI_PROJECT_TITLE}**\nНайдены предупреждения - <${CI_PAGES_URL}/${CI_PIPELINE_ID}|**iOS Lint Report**>\n\n**Коммит:** ${CI_COMMIT_TITLE}\n**Автор:** ${CI_COMMIT_AUTHOR}"
     }
EOF
exit 2
else
  echo "No errors/warnings. Good luck!"
  echo ${PAGE_DIRECTORY_NAME}
  exit 0
fi
