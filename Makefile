FLUTTER := /home/yazeed/flutter/bin/flutter

dev:
	$(FLUTTER) run --debug

build:
	$(FLUTTER) build apk --debug

logs:
	adb logcat -s flutter

clean:
	$(FLUTTER) clean && $(FLUTTER) pub get
