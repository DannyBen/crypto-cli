# Crypto exchange rates in the command line

This ruby script returns exchange rates for crypto currencies in the command
line.

## Prerequisites

- Ruby.
- API key (free) from [CoinAPI](https://www.coinapi.io/) (unaffiliated).

Note that the first time you run the script, it will install the
[Lightly gem](https://github.com/DannyBen/lightly) if it is not already
installed. Lightly is used for caching the results for 15 minutes, in order to avoid
exceeding your API quota.

## Install

The simplest way to install, is to run the [installation script](setup):

```shell
$ bash <(curl -Ls get.dannyb.co/crypto-cli/setup)
```

It will just download the [crypto](crypto) script to `/usr/local/bin`.

If you prefer to install manually, download the [crypto](crypto) script to
anywhere in your path and make it executable.

## Usage

```
$ crypto

Usage:
  crypto [<amount>] <from_currency> [to|in] [<to_currency>]

Examples:
  crypto btc
  crypto 0.5 eth
  crypto 0.5 eth usd
  crypto 0.5 eth to eur
  crypto doge in usd
```

## Caching

API calls are cached for 15 minutes in `/tmp/coinapi`.

## Credits

The CoinAPI code was adapted from the
[CoinAPI Ruby SDK](https://github.com/coinapi/coinapi-sdk/tree/master/data-api/ruby-rest)

