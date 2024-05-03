# react-native-ios-appattest

This library for React Native wraps Native iOS App Attest API's. AppAttest
API's can be used by an app to prove its integrity to backends. Apple's
documentation can be found [here](https://developer.apple.com/documentation/devicecheck/establishing-your-app-s-integrity).

Related repos:

- [`appattest-checker-node`](https://github.com/srinivas1729/appattest-checker-node):
  Server side library to check Attestations/Assertions generated by this library.
- [`hello-attestation-server-node`](https://github.com/srinivas1729/hello-attestation-server-node):
  Example API server that uses above library and provides an API that is guarded
  using Client Attestation.
- [`RNHelloAttestationClient`](https://github.com/srinivas1729/RNHelloAttestationClient):
  Example React Native app that uses this library to prove its integrity to `hello-attestation-server-node`.

## Consuming the library

```
$ npm install react-native-ios-appattest --save
// Link native components
$ cd ios && pod install && cd ..
```

In case you have build time issues with Flipper, disable Flipper while linking
native components.

```
NO_FLIPPER=1 pod install
```

**_Note_** Attestation is only supported on real devices, not on simulators.

## Generating an Attestation to provide device integrity

```typescript
import * as AppAttest from 'react-native-ios-appattest';

// First ensure the device supports attestation
const supported = await AppAttest.attestationSupported();
if (!supported) { /* handle accordingly */ }

// Generate key-pair in Secure-enclave.
const keyId = await AppAttest.generateKeys();

// Fetch a challenge/nonce from server.
const challengeHashBase64 = // compute SHA256 of challenge & get base64 of hash.

// Ask Apple to attest keys.
const attestationBase64 = await AppAttest.attestKeys(
  keyId,
  challengeHashBase64,
);
```

Send `attestationBase64` to your server. The server needs to check
the attestation object (and you can use [appattest-checker-node](https://github.com/srinivas1729/appattest-checker-node)).
If the checks pass, save the public key  for the client (which is embedded in
the attestation) in the server, indexed by some id for this device.

If the server confirms that attestationBase64 could be validated, client
should persist `keyId` string for use with request attestation.

## Attesting Requests

When the client needs to issue requests to the backend, it can generate
assertions for them, such that the backend can trust their integrity (e.g.
they came from the same device and haven't been tampered with)

```typescript

// Get challenge / nonce from the server.
const serverChallenge = <...>

// Compute body of high-value request and include challenge in it.
const requestBody = { /*...other stuff ...*/, challenge: serverChallenge };
const clientDataHashBase64 = // Compute SHA256 of requestBody & base64 of hash
// Note that when computing the hash, ensure a consistent representation of the
// body is used. E.g. json-stable-stringify can be used to generate a
// consistent string representation, before computing SHA256.

// Generate an attestation for the request using keyId generated earlier
const clientAttestationBase64 = await AppAttest.attestRequestData(
  clientDataHashBase64,
  this.keyId,
);
```

Send the request to the backend as normal and include `clientAttestationBase64`
(e.g. as an HTTP header). The server should needs to validate the attestation
before executing the request. It should use the previously saved public key for
the client. The request should be executed only if it the attestation passes
validation. [appattest-checker-node](https://github.com/srinivas1729/appattest-checker-node) provides an API to do this.
