/**
 * Checks if AppAttest is supported on this device.
 *
 * @returns {Promise<boolean>} A promise that resolves to 'true' if supported.
 */
export function attestationSupported(): Promise<boolean>;

/**
 * Generate key-pair in the Secure Enclave.
 *
 * @returns {Promise<string>} A promise that resolves to a keyId on success or rejects on failure
 *                            with error message.
 */
export function generateKeys(): Promise<string>;

/**
 * Request Apple to attest the validity of a generated key-pair.
 *
 * @param {string} keyId Key Id of Key to Attest
 * @param {string} challengeHashBase64
 * @returns {Promise<string>} A promise that resolves to the Attestation object (base64 encoded) on
 *                            success or rejects on failure with error message.
 */
export function attestKeys(
  keyId: string,
  challengeHashBase64: string
): Promise<string>;

/**
 * Sign request data with specified private key. The request data should be be unique each time
 * e.g. by including a one-time challenge in it. Also, instead of passing the entire request data,
 * the SHA256 hash of it should be computed and the base64 encoding of that should be provided.
 *
 * @param {string} requestDataHashBase64 Base64 encoding of SHA256 hash of request data to sign.
 * @param {string} keyId Key Id of private key to sign the
 * @returns {Promise<string>} A promise that resolves to the Assertion object (base64 encoded) on
 *                            success or rejects on failure with error message.
 */
export function attestRequestData(
  requestDataHashBase64: string,
  keyId: string
): Promise<string>;
