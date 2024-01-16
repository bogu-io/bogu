bogu: bogu.rkt \
	  local.rkt \
	  parser.rkt \
	  rules.rkt \
	  scanner.rkt \
	  strings.rkt \
	  walk.rkt \
	  github.rkt \
	  github-user.rkt
	raco exe bogu.rkt
	raco distribute build bogu
	zip -r9 bogu-$(BOGU_VERSION)-darwin-arm64.zip build

bogu-$(BOGU_VERSION)-linux-x64: bogu.rkt \
								local.rkt \
								parser.rkt \
								rules.rkt \
								scanner.rkt \
								strings.rkt \
								walk.rkt \
								github.rkt \
								github-user.rkt
	raco exe -o bogu-$(BOGU_VERSION)-linux-x64 bogu.rkt
	raco distribute build-linux bogu-$(BOGU_VERSION)-linux-x64
	zip -r9 bogu-$(BOGU_VERSION)-linux-x64.zip build-linux

clean:
	rm bogu || true
	rm bogu-*-linux-x64* || true
	rm bogu-*-darwin-arm64* || true
	rm -rf build* || true

