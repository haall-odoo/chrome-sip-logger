# chrome-sip-logger
Debian package that create a new GoogleChrome .desktop entry to get rotating logs to debug SIP and request change on VOIP provider with real logs if needed

The chrome-sip-logger.desktop is a duplicate of google-crome-stable.desktop wiht two lines changed (the base and new window Exec):
```
# L107
Exec=/usr/bin/google-chrome-stable %U
→
Exec=sh -c 'CHROME_LOG_FILE="/dev/stdout" /usr/bin/google-chrome-stable --enable-logging --vmodule="info.console"=1 %U | grep -E sip | systemd-cat -t sip.logger'
```
```
# L169
Exec=/usr/bin/google-chrome-stable
→ 
Exec=sh -c 'CHROME_LOG_FILE="/dev/stdout" /usr/bin/google-chrome-stable --enable-logging --vmodule="info.console"=1 | grep -E sip | systemd-cat -t sip.logger'
```

This configuration allow to run normal Google Chrome frome `google-chrome-stable.deskop`and also the SIP logger through `chrome-sip-logger.desktop`.
Both relying on the sole `google-chrome-stable` binary.
- `CHROME_LOG_FILE`is the environment variable defining where `google-chrome-stable` will writte all logs
  - This avoid to get a text file that soon became too fat.
- `--enable-logging`is used to enbale the logging system (really, so suprising)
- `--vmodule='info.console'=1` is used to captured only log coming form the JS/Web console, other module can be defined if needed, `--v=1` can be used to capture all `google-chrome-stable` logs.
- `grep -E sip` is used to filter JS console output and keep only info.console that are SIP related
- `systemd-cat` is used to transfer stdout to the journal, and the flag `-t` allows developper to define an identifier to ease the retrieval

The full command is a pipeline that take the outputs logs of google chrome filter them and store the SIP relevant information in journal under the identifier `sip.logger`.

Rotation handled by journald.