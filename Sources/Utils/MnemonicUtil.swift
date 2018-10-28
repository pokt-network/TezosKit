import MnemonicKit

/**
 * A static utility wrapper class for CKMnemonic which provides syntactic sugar to transform
 * exceptions into optionals.
 */
public class MnemonicUtil {

	/**
   * Generate a mnemonic.
   */
	public static func generateMnemonic() -> String? {
    return Mnemonic.generateMnemonic(strength: 128)
	}

	/**
   * Generate a seed string from a given mnemonic.
   *
   * @param mnemonic A BIP39 mnemonic phrase.
   * @param passphrase An optional passphrase used for encryption.
   */
	public static func seedString(from mnemonic: String, passphrase: String = "") -> String? {
    let rawSeedString =
			Mnemonic.deterministicSeedString(from: mnemonic, passphrase: passphrase)
    return String(rawSeedString[..<rawSeedString.index(rawSeedString.startIndex, offsetBy: 64)])
	}

	/** Please do not instantiate this static utility class. */
	private init() { fatalError() }
}
