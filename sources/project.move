module MyModule::SimpleVault {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a simple vault storing deposited coins
    struct Vault has store, key {
        balance: u64,
    }

    /// Initialize the vault for the user
    public fun create_vault(account: &signer) {
        let vault = Vault { balance: 0 };
        move_to(account, vault);
    }

    /// Deposit AptosCoin into the user's vault
    public fun deposit(account: &signer, amount: u64) acquires Vault {
        let vault = borrow_global_mut<Vault>(signer::address_of(account));

        // Withdraw AptosCoin from user and deposit into vault
        let coins = coin::withdraw<AptosCoin>(account, amount);
        coin::deposit<AptosCoin>(signer::address_of(account), coins);

        // Update vault balance
        vault.balance = vault.balance + amount;
    }
}
