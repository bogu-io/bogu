bogu: bogu.rkt local.rkt parser.rkt rules.rkt scanner.rkt strings.rkt walk.rkt
	raco exe bogu.rkt
	raco distribute build bogu

clean:
	rm bogu