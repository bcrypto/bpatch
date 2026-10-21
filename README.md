# bpatch: BTLS for OpenSSL

Patches OpenSSL sources to support the Belarusian TLS ciphersuites:
- TLS 1.2, STB 34.101.65: `DHE-BIGN-WITH-BELT-CTR-MAC-HBELT`,
  `DHE-BIGN-WITH-BELT-DWP-HBELT`, `DHT-BIGN-WITH-BELT-CTR-MAC-HBELT`,
  `DHT-BIGN-WITH-BELT-DWP-HBELT` and their `PSK` variants;
- TLS 1.3, STB 34.101.90: `TLS_BELT_CHE256_BELT_HASH`,
  `TLS_BASH_PRG_AE2561_BASH256`, bign groups and signature algorithms.

Used as a submodule by [bee2evp](https://github.com/bcrypto/bee2evp) (engine)
and [bee2prv](https://github.com/bcrypto/bee2prv) (provider).

## Usage

```
./apply.sh <openssl source root> [--dry-run|--check|--revert] [--provider]
```

Rules are selected by the OpenSSL version (layout of the sources) and by the
build mode: `engine` for bee2evp on OpenSSL 3.x (default), `provider` for
bee2prv. OpenSSL 4 has no engines and is always built in the `provider` mode;
for OpenSSL 3.5 with bee2prv pass `--provider` or set `BTLS_PROVIDER=1`.

Without an option, `apply.sh` copies `btls/btls.{c,h}` (`btls/legacy` for
OpenSSL 1.1.1) into `ssl/`, registers the identifiers from `btls/objects.txt`
(OpenSSL 3+) and applies the rules from `btls_rules.py` with `patcher.py`.
Code fragments of the rules are in `snippets`.

For OpenSSL 3+, run `make update` after `Configure` to regenerate the object
headers from `objects.txt`.

Supported OpenSSL versions: 1.1.1, 3.0 and 3.5 (LTS), 4.0. Version 3.3 is kept
working for existing builds. Other versions are not tested.

`patch` holds the old diff-style patches for fixed OpenSSL versions.

## License

Apache License version 2.0, see [LICENSE](LICENSE).
