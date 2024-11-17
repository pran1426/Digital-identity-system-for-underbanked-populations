module Digitalidentitysystemforunderbankedpopulations {

    /// Struct to store the user's identity information
    struct Identity has store {
        name: vector<u8>,       // User's name
        national_id: vector<u8> // User's national ID
    }

    /// A resource to store identities associated with each account
    resource struct Identities has store {
        identities: table::Table<address, Identity>
    }

    /// Initialize the Identities resource for the first time
    public fun initialize(account: &signer) {
        if (!exists<Identities>(signer::address_of(account))) {
            move_to(account, Identities { 
                identities: table::new<address, Identity>()
            });
        }
    }

    /// Function to register an identity
    public fun register_identity(
        account: &signer,
        name: vector<u8>,
        national_id: vector<u8>
    ) {
        let identities = borrow_global_mut<Identities>(signer::address_of(account));
        table::add(
            &mut identities.identities,
            signer::address_of(account),
            Identity { name, national_id }
        );
    }

    /// Function to get an identity
    public fun get_identity(account: address): Option<Identity> {
        if (exists<Identities>(account)) {
            let identities = borrow_global<Identities>(account);
            table::lookup(&identities.identities, account)
        } else {
            Option::none<Identity>()
        }
    }
}
