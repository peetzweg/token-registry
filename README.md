# Token Information Registry

## Abstract

The **Token Information Registry** proposed in this repository is suggestion to create a decentralized trustless and future proof source of auxiliary token information of all kind. Furthermore, it offers an interface to read multiple pieces of information of a single and many tokens in a single RPC call.

Our current token standards leave out certain bits of information we humans come to rely on like an icon representing the token or an official website. These pieces of data are by design not required in our standards for good reasons.

However, the absence of this data urges everyone who is building a human facing interface for tokens to gather this information themselves. Due to the amount of tokens, this is a cumbersome task. Resulting in another popular approach, to use an existing dataset from a third party. Ranging closed source APIs like Coingecko or Coinmarketcap to more open solutions in a git repository like Trustwallets (https://github.com/trustwallet/assets), which is used by Sushi- and Uniswap.

Although these solutions do work, they are neither tamper proof nor trustless. This information is critical to how humans perceive tokens in interfaces. As described this data is most likely not provided by the token issuer and thereby at risk to be wrong, outdated or misused.



## Contributing

You will need a copy of [Foundry](https://github.com/foundry-rs/foundry) installed before proceeding. See the [installation guide](https://github.com/foundry-rs/foundry#installation) for details.


### Run Tests

```sh
forge test
```


## Appendix

- Initial Ethereum Magicians Post: https://ethereum-magicians.org/t/eip-idea-token-information-service/10572

- Trustwallet `assets` repository: https://github.com/trustwallet/assets